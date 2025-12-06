from flask import Flask, render_template, request, redirect, url_for, flash
import pyodbc

app = Flask(__name__)
app.secret_key = 'key_bao_mat'

# Hàm kết nối
def get_db_connection():
    return pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=K;' #Thay ten server vao day (vao sql de xem ten server minh)
        'DATABASE=ECommerceDB;' #Thay ten database vao 
        'Trusted_Connection=yes;'
    )

# --- 1. CHỨC NĂNG: DANH SÁCH & TÌM KIẾM (Gọi Procedure 2.3) ---
@app.route('/', methods=['GET'])
def index():
    keyword = request.args.get('keyword', '')
    users = []
    conn = get_db_connection()
    cursor = conn.cursor()

    if keyword:
        cursor.execute("{CALL sp_LayTenNguoiMua(?)}", (keyword,))
        users = cursor.fetchall()

    else:
        # Nếu không tìm kiếm thì hiện top 10 người mua
        cursor.execute("SELECT TOP 10 ma_nguoi_mua, ten_hien_thi, email, so_dien_thoai FROM nguoi_mua")
        users = cursor.fetchall()
        
    conn.close()
    return render_template('list_users.html', users=users, keyword=keyword)

# --- 2. CHỨC NĂNG: THÊM MỚI (Gọi Procedure 2.1.1) ---
@app.route('/add', methods=['GET', 'POST'])
def add_user():
    if request.method == 'POST':
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            
            # Lấy dữ liệu từ Form
            ma = request.form['ma']
            ten = request.form['ten']
            passw = request.form['pass']
            dob = request.form['dob']
            email = request.form['email']
            phone = request.form['phone']

            # Gọi Procedure sp_ThemNguoiMua
            cursor.execute("{CALL sp_ThemNguoiMua (?, ?, ?, ?, ?, ?)}", 
                           (ma, ten, passw, dob, email, phone))
            conn.commit()
            flash('Thêm thành công!', 'success')
            return redirect(url_for('index'))

        except pyodbc.Error as ex:
            flash(f'Lỗi SQL: {ex}', 'danger') 
            return redirect(url_for('index'))
        finally:
            if 'conn' in locals(): conn.close()
            
    return render_template('add_user.html')

# --- 3. CHỨC NĂNG: XÓA (Gọi Procedure 2.1.3) ---
@app.route('/delete/<string:ma_nguoi_mua>')
def delete_user(ma_nguoi_mua):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Gọi SP Xóa 
        cursor.execute("{CALL sp_XoaNguoiMua (?)}", (ma_nguoi_mua,))
        conn.commit()
        flash('Đã xóa người mua!', 'warning')
        
    except pyodbc.Error as ex:
        flash(f'Lỗi khi xóa: {ex.args[1]}', 'danger')
        
    return redirect(url_for('index'))

@app.route('/update/<string:ma_nguoi_mua>', methods=['POST', 'GET']) #Cap nhat ten, email, sdt moi
def update_user(ma_nguoi_mua):
    if request.method == 'POST':
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            
            # Lấy dữ liệu từ Form
            ma = ma_nguoi_mua
            ten = request.form['ten']
            email = request.form['email']
            phone = request.form['phone']

            # Gọi Procedure sp_ThemNguoiMua
            cursor.execute("{CALL sp_SuaNguoiMua (?, ?, ?, ?)}", 
                           (ma, ten, email, phone))
            conn.commit()
            flash('Sửa thành công!', 'success')
            return redirect(url_for('index'))

        except pyodbc.Error as ex:
            msg = ex.args[1] 
            error_message = msg.split(']')[1] if ']' in msg else msg 
            flash(f'Lỗi SQL: {error_message}', 'danger')
        finally:
            if 'conn' in locals(): conn.close()
    else: 
        cursor.execute("SELECT * FROM nguoi_mua WHERE ma_nguoi_mua = ?", (ma_nguoi_mua,))
        user_info = cursor.fetchone()
        conn.close()
        
        if user_info:
            return render_template('edit_user.html', user=user_info)
        else:
            flash('Người dùng không tồn tại!', 'danger')
            return redirect(url_for('index'))        
    return render_template('edit_user.html')

# =======================================================
# MỤC 3.2: GIAO DIỆN BÁO CÁO DOANH THU (Gọi sp_ThongKeDoanhThuSanPham)
# Yêu cầu: Hiển thị danh sách, Search, Filter
# =======================================================
@app.route('/report', methods=['GET', 'POST'])
def report_revenue():
    # Giá trị mặc định
    import datetime
    today = datetime.date.today()
    thang = request.form.get('thang', today.month)
    nam = request.form.get('nam', today.year)
    min_qty = request.form.get('min_qty', 0)
    
    results = []
    total_revenue = 0

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        if int(min_qty) < 0:
            flash("Số lượng bán tối thiểu phải >= 0", "danger")
        else: 
            cursor.execute("{CALL sp_ThongKeDoanhThuSanPham (?, ?, ?)}", 
                        (int(thang), int(nam), int(min_qty)))
            results = cursor.fetchall()
            
            # Tính tổng doanh thu toàn bảng để hiển thị footer
            for row in results:
                total_revenue += row[3] # Cột thứ 4 là doanh thu 

    except pyodbc.Error as ex:
        flash(f'Lỗi khi lấy báo cáo: {ex.args[1]}', 'danger')
    finally:
        conn.close()

    return render_template('report_revenue.html', 
                           results=results, 
                           thang=thang, 
                           nam=nam, 
                           min_qty=min_qty,
                           total_revenue=total_revenue)

# =======================================================
# MỤC 3.3: GIAO DIỆN MINH HỌA HÀM (Gọi fn_TinhTongGiaTriChietKhau)
# Yêu cầu: Gọi hàm tính toán và hiển thị kết quả
# =======================================================
@app.route('/discount/<string:ma_nguoi_mua>')
def check_discount(ma_nguoi_mua):
    discount_value = 0
    buyer_name = ""
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        # 1. Lấy tên người mua để hiển thị cho đẹp
        cursor.execute("SELECT ten_hien_thi FROM nguoi_mua WHERE ma_nguoi_mua = ?", (ma_nguoi_mua,))
        row = cursor.fetchone()
        if row:
            buyer_name = row[0]
            
        # 2. GỌI HÀM SCALAR TRONG SQL SERVER
        # Cú pháp: SELECT dbo.TenHam(?)
        cursor.execute("SELECT dbo.fn_TinhTongGiaTriChietKhau(?)", (ma_nguoi_mua,))
        result = cursor.fetchone()
        
        if result:
            discount_value = result[0]
            
            # Xử lý trường hợp hàm trả về -1 (Không tìm thấy user - logic trong SQL)
            if discount_value == -1:
                flash('Lỗi: Mã người mua không tồn tại trong hệ thống.', 'danger')
                return redirect(url_for('index'))

    except pyodbc.Error as ex:
        flash(f'Lỗi SQL: {ex}', 'danger') 
        return redirect(url_for('index'))
    finally:
        conn.close()

    # Render ra một trang kết quả riêng (hoặc dùng flash cũng được, nhưng làm trang riêng đúng chuẩn 3.3 hơn)
    return render_template('view_discount.html', 
                           ma=ma_nguoi_mua, 
                           ten=buyer_name, 
                           tien=discount_value)

if __name__ == '__main__':
    app.run(debug=True)
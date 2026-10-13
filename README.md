# MedStudy Cloud

Trang học M8–M11 cho DY18A. `index.html` là bản web có đăng ký/đăng nhập, bộ câu hỏi riêng cho từng bài, đọc tài liệu HTML/Word/PDF, kiểm tra đạt 85% và đồng bộ dữ liệu theo tài khoản.

## Đưa lên GitHub Pages

1. Đẩy thư mục này lên repository `jeznopro/web-hust`.
2. Trong GitHub, mở **Settings → Pages**, chọn **Deploy from a branch**, nhánh `main`, thư mục `/ (root)` rồi lưu. Địa chỉ dự kiến sẽ là `https://jeznopro.github.io/web-hust/` sau khi GitHub Pages xuất bản thành công.
3. Tạo dự án Supabase. Trong **SQL Editor**, chạy nội dung của [`medstudy-cloud-setup.sql`](medstudy-cloud-setup.sql). File này tạo bảng và kho lưu tài liệu riêng cho từng người dùng, kèm chính sách truy cập.
4. Trong **Authentication → URL Configuration**, đặt **Site URL** là URL GitHub Pages thực tế và thêm cùng URL vào **Redirect URLs**.
5. Mở trang MedStudy, nhập **Project URL** và **publishable key** từ Supabase. Không nhập secret/service_role key. Thông tin kết nối này được giữ trong trình duyệt; khi có dự án Supabase, có thể nhúng thông tin công khai đó vào bản build để người dùng không phải nhập trên từng thiết bị.

Trang cần kết nối Internet để tải thư viện Supabase và đồng bộ.

## Chuyển dữ liệu từ bản cũ

Ở bản HTML cũ, vào **Ôn câu sai → Xuất bản sao tiến độ**. Sau khi đăng nhập trang mới, dùng **Khôi phục bản sao** ở cùng mục. Bản sao JSON chuyển được bộ câu hỏi, ghi chú và tiến độ; các file HTML/Word/PDF cần tải lên lại.

## Phạm vi hiện tại

Mỗi lần lưu đồng bộ toàn bộ tiến độ của tài khoản. Nếu cùng một tài khoản sửa đồng thời trên hai thiết bị, lần lưu sau có thể ghi đè lần trước. Hãy tải lại trang khi chuyển thiết bị.

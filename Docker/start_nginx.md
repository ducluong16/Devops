Dưới đây là một ví dụ về việc chạy Nginx bằng Docker Compose, có sử dụng cả `network`, `port`, và `volume`:

### Bước 1: Tạo file `docker-compose.yml`

```yaml
version: "3"
services:
  nginx:
    image: nginx:latest
    ports:
      - "8080:80" # Chuyển tiếp cổng 8080 trên máy host sang cổng 80 của container
    volumes:
      - ./nginx/html:/usr/share/nginx/html # Gắn thư mục hiện tại chứa HTML vào thư mục Nginx trong container
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf # Gắn file cấu hình Nginx
    networks:
      - my_network

networks:
  my_network:
    driver: bridge # Sử dụng bridge network cho container
```

### Bước 2: Tạo cấu trúc thư mục

- Tạo các thư mục và file cần thiết trong thư mục hiện tại:

```bash
mkdir -p nginx/html
touch nginx/html/index.html
touch nginx/nginx.conf
```

- Nội dung mẫu cho `index.html`:

  ```html
  <!DOCTYPE html>
  <html>
    <head>
      <title>Welcome to Nginx!</title>
    </head>
    <body>
      <h1>Hello from Docker Compose!</h1>
    </body>
  </html>
  ```

- Nội dung mẫu cho `nginx.conf`:

  ```nginx
  user  nginx;  # Chạy Nginx dưới quyền user 'nginx'
  worker_processes  auto;  # Tự động xác định số lượng tiến trình worker dựa trên số lượng CPU
  error_log  /var/log/nginx/error.log warn;  # Đường dẫn file log lỗi và mức độ log
  pid        /var/run/nginx.pid;  # Đường dẫn file PID của Nginx

  events {
          worker_connections  1024;  # Số lượng kết nối tối đa mỗi worker có thể xử lý
  }

  http {
          include       /etc/nginx/mime.types;  # Định nghĩa các loại MIME
          default_type  application/octet-stream;  # Loại MIME mặc định
          sendfile        on;  # Bật chế độ sendfile để cải thiện hiệu suất
          keepalive_timeout  65;  # Thời gian giữ kết nối sống

          server {
                  listen       80;  # Lắng nghe trên cổng 80
                  server_name  localhost;  # Tên server

                  location / {
                          root   /usr/share/nginx/html;  # Thư mục gốc chứa các file HTML
                          index  index.html index.htm;  # Các file index mặc định
                  }
          }
  }
  ```

  ```

  ```

### Bước 3: Khởi động Docker Compose

Chạy lệnh sau để khởi động Nginx với Docker Compose:

```bash
docker-compose up
```

### Bước 4: Kiểm tra

- Truy cập `http://localhost:8080` trên trình duyệt để xem trang web với nội dung từ `index.html`.

### Diễn giải:

- **`ports`**: Chuyển tiếp cổng 8080 trên máy chủ (host) sang cổng 80 của container, nơi Nginx lắng nghe.
- **`volumes`**:
  - Gắn thư mục `nginx/html` từ máy chủ vào thư mục `/usr/share/nginx/html` trong container để chứa các file HTML.
  - Gắn file cấu hình Nginx `nginx.conf` vào container để cấu hình Nginx theo ý muốn.
- **`networks`**: Sử dụng mạng `my_network` với driver `bridge`, giúp các container có thể giao tiếp qua mạng nội bộ.

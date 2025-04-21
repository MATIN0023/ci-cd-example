# مرحله Build
FROM node:18-alpine AS builder

# ست کردن ورک‌دایرکتوری داخل کانتینر
WORKDIR /app

# کپی کردن فایل‌های dependency
COPY package*.json ./

# نصب پکیج‌ها
RUN npm install

# کپی باقی فایل‌ها
COPY . .

# بیلد پروژه
RUN npm run build

# مرحله Production
FROM nginx:alpine

# پاک کردن default config nginx
RUN rm -rf /usr/share/nginx/html/*

# کپی فایل‌های بیلد شده از مرحله قبلی
COPY --from=builder /app/dist /usr/share/nginx/html

# در صورت استفاده از React یا Vue Router برای SPA
COPY nginx.conf /etc/nginx/conf.d/default.conf

# اکسپوز کردن پورت
EXPOSE 80

# اجرای Nginx
CMD ["nginx", "-g", "daemon off;"]

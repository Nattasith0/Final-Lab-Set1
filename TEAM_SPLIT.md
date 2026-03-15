# TEAM_SPLIT.md

## ข้อมูลกลุ่ม
- กลุ่มที่: 1
- รายวิชา: ENGSE207 Software Architecture

## รายชื่อสมาชิก
- 67543210056-7 นายณัฐสิทธิ์ มะโนชัย
- 67543210053-4 นายฐิติภัทร์  ชุ่มมา

## การแบ่งงานหลัก

### สมาชิกคนที่ 1: นายณัฐสิทธิ์ มะโนชัย
รับผิดชอบงานหลักดังต่อไปนี้
- Auth Service — Login route, JWT sign/verify, bcrypt password check
- Nginx — HTTPS config, self-signed certificate, rate limiting, reverse proxy
- Database — ออกแบบ schema (users, tasks, logs) และ seed users
- Docker Compose — ตั้งค่า services, networks, healthcheck, environment variables

### สมาชิกคนที่ 2: นายฐิติภัทร์  ชุ่มมา
รับผิดชอบงานหลักดังต่อไปนี้
- Task Service — CRUD tasks, JWT middleware, role-based access (admin/member)
- Log Service — รับ log จาก services, บันทึกลง DB, GET /api/logs/ พร้อม admin guard
- Frontend — index.html (Task Board UI), logs.html (Log Dashboard)
- ทดสอบระบบ end-to-end และจัดทำ screenshots ทั้ง 12 รูป

## งานที่ดำเนินการร่วมกัน
- ออกแบบ architecture diagram และ flow ของระบบร่วมกัน
- ทดสอบระบบ end-to-end ร่วมกันผ่าน Postman
- จัดทำ README.md และเอกสารประกอบการส่งงาน
- แก้ปัญหา npm ci ที่เกิดจากไม่มี package-lock.json ร่วมกัน

## เหตุผลในการแบ่งงาน
แบ่งงานตาม service boundary โดยสมาชิกคนที่ 1 รับผิดชอบด้าน security layer
(Auth + Nginx + HTTPS) ซึ่งเป็นพื้นฐานที่ services อื่นต้องพึ่งพา
สมาชิกคนที่ 2 รับผิดชอบ business logic layer (Task + Log + Frontend)
ที่ต้องทำงานต่อจาก auth flow ที่ตั้งค่าไว้แล้ว

## สรุปการเชื่อมโยงงานของสมาชิก
- Auth Service (คนที่ 1) ออก JWT → Task Service และ Log Service (คนที่ 2) ใช้ JWT
  ตรวจสอบสิทธิ์ก่อนให้เข้าถึง resource
- Nginx (คนที่ 1) เป็น entry point รับ request จาก browser แล้ว route ไปยัง
  services ของทั้งสองคน
- Log Service (คนที่ 2) รับ log event จาก Auth Service และ Task Service ผ่าน
  POST /api/logs/internal ภายใน Docker network
- Frontend (คนที่ 2) เรียก API ทุกตัวผ่าน HTTPS ที่ Nginx (คนที่ 1) ตั้งค่าไว้
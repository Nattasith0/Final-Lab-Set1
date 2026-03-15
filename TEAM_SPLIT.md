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

การแบ่งหน้าที่พิจารณาตามขอบเขตของแต่ละ service เพื่อให้การพัฒนาระบบเป็นไปอย่างชัดเจน
สมาชิกคนที่ 1 ดูแลส่วนของ **security layer** ได้แก่ Auth Service, การตั้งค่า Nginx และการใช้งาน HTTPS ซึ่งเป็นโครงสร้างพื้นฐานสำคัญที่บริการอื่น ๆ ต้องใช้ร่วมกัน

ส่วนสมาชิกคนที่ 2 รับผิดชอบ **business logic layer** ประกอบด้วย Task Service, Log Service และ Frontend ซึ่งเป็นส่วนการทำงานหลักของระบบ และต้องเชื่อมต่อการทำงานต่อจากกระบวนการ authentication ที่ได้ตั้งค่าไว้แล้ว


## สรุปการเชื่อมโยงงานของสมาชิก
- Auth Service (คนที่ 1) ออก JWT → Task Service และ Log Service (คนที่ 2) ใช้ JWT
  ตรวจสอบสิทธิ์ก่อนให้เข้าถึง resource
- Nginx (คนที่ 1) เป็น entry point รับ request จาก browser แล้ว route ไปยัง
  services ของทั้งสองคน
- Log Service (คนที่ 2) รับ log event จาก Auth Service และ Task Service ผ่าน
  POST /api/logs/internal ภายใน Docker network
- Frontend (คนที่ 2) เรียก API ทุกตัวผ่าน HTTPS ที่ Nginx (คนที่ 1) ตั้งค่าไว้
# INDIVIDUAL_REPORT_65XXXXXXX.md

## ข้อมูลผู้จัดทำ
- ชื่อ-นามสกุล: นายฐิติภัทร์  ชุ่มมา
- รหัสนักศึกษา: 67543210053-4
- กลุ่ม: 11

## ขอบเขตงานที่รับผิดชอบ
- Task Service — CRUD tasks ครบ 4 operations, JWT middleware, role-based access
- Log Service — รับ log จาก services อื่น, บันทึกลง DB, GET /api/logs/ admin only
- Frontend — index.html (Task Board UI), logs.html (Log Dashboard ดึงจาก API จริง)
- ทดสอบระบบ end-to-end ผ่าน Postman และจัดทำ screenshots ทั้ง 12 รูป

## สิ่งที่ได้ดำเนินการด้วยตนเอง
- เขียน JWT middleware ใน task-service ให้ตรวจสอบ Bearer token
  และส่ง JWT_INVALID log ไป log-service เมื่อ token ผิด
- เขียน GET /api/tasks/ ให้ admin เห็นทุก task แต่ member เห็นเฉพาะของตัวเอง
- เพิ่ม logEvent() ใน task-service เพื่อส่ง TASK_CREATED และ TASK_DELETED
- เขียน log-service ทั้งหมด รวมถึง POST /api/logs/internal สำหรับ internal use
  และ GET /api/logs/ ที่จำกัดเฉพาะ admin token เท่านั้น
- ดัดแปลง Frontend จาก Week 12 โดยลบ Register tab ออก เปลี่ยน API endpoint
  เป็น https://localhost และแก้ logs.html ให้ดึงข้อมูลจาก GET /api/logs/ จริง
  แทนการอ่านจาก localStorage
- ทดสอบทุก test case ผ่าน Postman และถ่าย screenshots ครบ 12 รูป

## ปัญหาที่พบและวิธีการแก้ไข
**ปัญหา 1: logs.html แสดง 403 Forbidden แม้จะ login แล้ว**
เกิดจาก login ด้วย alice ซึ่งมี role เป็น member
log-service ตรวจสอบ role ก่อนให้ดูข้อมูล
แก้โดยเปลี่ยนไป login ด้วย admin@lab.local แล้ว logs.html จึงแสดงข้อมูลได้

**ปัญหา 2: PUT /api/tasks/:id ได้ 404 จาก Postman**
เกิดจากตั้ง Method เป็น POST แทน PUT
แก้โดยเปลี่ยน method dropdown ใน Postman เป็น PUT

## สิ่งที่ได้เรียนรู้จากงานนี้
- เข้าใจ Lightweight Logging ว่าแตกต่างจาก Loki/Grafana ตรงที่เราเขียน
  log service เองและเก็บลง PostgreSQL โดยตรง ง่ายกว่าแต่ขาด real-time
  visualization และ alerting
- เข้าใจ role-based access control ว่า JWT payload เก็บ role ไว้
  และ middleware ตรวจสอบ role ก่อนอนุญาตให้เข้าถึง resource
- เข้าใจ internal network ของ Docker ว่า services คุยกันผ่าน
  service name เช่น http://log-service:3003 โดยไม่ผ่าน Nginx
- เข้าใจว่าการแยก Frontend ออกเป็น static service ทำให้ Nginx serve
  HTML ได้โดยตรงและ browser เรียก API ผ่าน HTTPS ได้ถูกต้อง

## แนวทางการพัฒนาต่อไปใน Set 2
- เพิ่ม User Service แยกออกมาจาก Auth Service เพื่อจัดการ profile
  และ user management โดยเฉพาะ
- แยก database ของแต่ละ service ออกจากกัน โดยเฉพาะ logs table
  ควรอยู่ใน log-service database เท่านั้น
- เพิ่ม pagination และ filter ที่ดีขึ้นใน Log Dashboard
- Deploy บน Railway Cloud โดยตั้งค่า environment variables
  และ managed PostgreSQL แทนการรันบน localhost
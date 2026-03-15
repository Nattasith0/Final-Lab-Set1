# INDIVIDUAL_REPORT_67543210053.md

## ข้อมูลผู้จัดทำ

* ชื่อ-นามสกุล: นายฐิติภัทร์ ชุ่มมา
* รหัสนักศึกษา: 67543210053-4
* กลุ่ม: 11

## ขอบเขตงานที่รับผิดชอบ

* **Task Service** — พัฒนาฟังก์ชันจัดการงาน (Task) ครบทั้ง 4 รูปแบบของ CRUD พร้อมเพิ่ม JWT middleware และกำหนดสิทธิ์การใช้งานตามบทบาทของผู้ใช้ (role-based access)
* **Log Service** — ออกแบบระบบรับ log จาก service อื่น ๆ แล้วบันทึกข้อมูลลงฐานข้อมูล พร้อมสร้าง endpoint `GET /api/logs/` ที่อนุญาตให้เฉพาะผู้ใช้ระดับ admin เรียกดูได้
* **Frontend** — สร้างหน้า `index.html` สำหรับแสดง Task Board และหน้า `logs.html` สำหรับแสดง Log Dashboard โดยดึงข้อมูลจาก API
* ทำการทดสอบการทำงานของระบบแบบ end-to-end ผ่าน Postman และจัดเตรียม screenshots สำหรับรายงานจำนวน 12 ภาพ

## สิ่งที่ได้ดำเนินการด้วยตนเอง

* พัฒนา JWT middleware ใน **task-service** เพื่อใช้ตรวจสอบ Bearer Token ก่อนเข้าถึง API
  และหากพบ token ไม่ถูกต้องจะส่ง log ประเภท `JWT_INVALID` ไปยัง log-service
* พัฒนา endpoint `GET /api/tasks/` โดยกำหนดให้ผู้ใช้ role **admin** สามารถเห็น task ทั้งหมด
  ส่วนผู้ใช้ role **member** จะเห็นเฉพาะ task ของตนเอง
* เพิ่มฟังก์ชัน `logEvent()` ภายใน task-service เพื่อส่ง log เช่น `TASK_CREATED` และ `TASK_DELETED` ไปยัง log-service
* พัฒนา **log-service** ทั้งระบบ รวมถึง endpoint `POST /api/logs/internal` สำหรับการเรียกใช้ภายในระบบ
  และ endpoint `GET /api/logs/` ซึ่งจำกัดการเข้าถึงเฉพาะผู้ใช้ที่มีสิทธิ์ admin
* ปรับปรุง Frontend จากเวอร์ชัน **Week 12** โดยลบแท็บ Register ออก เปลี่ยน endpoint ของ API ให้ใช้ `https://localhost`
  และปรับหน้า `logs.html` ให้ดึงข้อมูลจาก `GET /api/logs/` โดยตรงแทนการอ่านข้อมูลจาก `localStorage`
* ทำการทดสอบทุกกรณีด้วย Postman และบันทึก screenshots ตามเงื่อนไขของงานครบทั้ง 12 ภาพ

## ปัญหาที่พบและวิธีการแก้ไข

**ปัญหา 1: หน้า logs.html แสดงข้อความ 403 Forbidden แม้จะทำการ login แล้ว**
สาเหตุเกิดจากการ login ด้วยบัญชี **alice** ซึ่งมี role เป็น member
โดย log-service มีการตรวจสอบ role ก่อนอนุญาตให้เข้าถึงข้อมูล log
จึงแก้ไขโดยเปลี่ยนไป login ด้วยบัญชี **[admin@lab.local](mailto:admin@lab.local)** ทำให้สามารถเข้าดูข้อมูลได้ตามปกติ

**ปัญหา 2: การเรียก PUT /api/tasks/:id จาก Postman ได้สถานะ 404**
สาเหตุเกิดจากการเลือก HTTP Method เป็น **POST** แทนที่จะเป็น **PUT**
จึงแก้ไขโดยปรับ method ใน Postman ให้ถูกต้องเป็น **PUT**

## สิ่งที่ได้เรียนรู้จากงานนี้

* ได้เรียนรู้แนวคิดของ **Lightweight Logging System** ซึ่งแตกต่างจากการใช้เครื่องมืออย่าง Loki หรือ Grafana
  เนื่องจากเป็นการสร้าง log service ขึ้นมาเองและจัดเก็บข้อมูลลง PostgreSQL โดยตรง
  แม้จะมีโครงสร้างที่เรียบง่าย แต่จะไม่มีความสามารถด้าน visualization และ alert แบบ real-time
* เข้าใจหลักการของ **Role-Based Access Control (RBAC)** โดยเก็บ role ไว้ใน JWT payload
  และให้ middleware ตรวจสอบสิทธิ์ก่อนอนุญาตให้เข้าถึง resource ต่าง ๆ
* ได้เข้าใจการทำงานของ **Docker internal network** ที่แต่ละ service สามารถติดต่อกันผ่านชื่อ service
  เช่น `http://log-service:3003` โดยไม่จำเป็นต้องผ่าน Nginx
* เข้าใจแนวคิดของการแยก **Frontend เป็น static service** ซึ่งทำให้ Nginx สามารถให้บริการไฟล์ HTML ได้โดยตรง
  และช่วยให้ browser เรียกใช้ API ผ่าน HTTPS ได้อย่างถูกต้อง

## แนวทางการพัฒนาต่อไปใน Set 2

* แยก **User Service** ออกจาก Auth Service เพื่อใช้จัดการข้อมูลผู้ใช้และ profile ได้อย่างเป็นระบบมากขึ้น
* ปรับโครงสร้างฐานข้อมูลให้แต่ละ service มี database ของตนเอง เช่น logs table ควรถูกจัดเก็บในฐานข้อมูลของ log-service เท่านั้น
* พัฒนา **Log Dashboard** ให้มีระบบ pagination และตัวกรองข้อมูล (filter) ที่มีประสิทธิภาพมากขึ้น
* เตรียมระบบสำหรับการ deploy บน **Railway Cloud** โดยกำหนดค่า environment variables และใช้ managed PostgreSQL แทนการรันบน localhost

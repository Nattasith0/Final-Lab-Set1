# INDIVIDUAL_REPORT_67543210056.md

## ข้อมูลผู้จัดทำ
- ชื่อ-นามสกุล: นายณัฐสิทธิ์ มะโนชัย
- รหัสนักศึกษา: 67543210056-7
- กลุ่ม: 11

## ขอบเขตงานที่รับผิดชอบ
- Auth Service — Login route, JWT sign/verify, bcrypt password check, logEvent helper
- Nginx — HTTPS config, self-signed certificate, rate limiting, reverse proxy routing
- Database — ออกแบบ schema ตาราง users, tasks, logs และ seed users ทั้ง 3 บัญชี
- Docker Compose — ตั้งค่า services, networks, healthcheck, environment variables

## สิ่งที่ได้ดำเนินการด้วยตนเอง
- เขียน POST /api/auth/login ให้ตรวจสอบ bcrypt hash และออก JWT token
- เขียน GET /api/auth/verify และ /api/auth/me สำหรับตรวจสอบ token
- เพิ่ม logEvent() helper ใน auth-service เพื่อส่ง LOGIN_SUCCESS และ LOGIN_FAILED
  ไปยัง log-service ผ่าน POST /api/logs/internal
- ตั้งค่า nginx.conf ให้ redirect HTTP → HTTPS และกำหนด rate limit
  login endpoint ที่ 5 req/นาที
- สร้าง self-signed certificate ด้วย openssl สำหรับ development
- เขียน db/init.sql สร้างตาราง users, tasks, logs พร้อม index และ seed users
- Generate bcrypt hash จริงสำหรับ alice123, bob456, adminpass ด้วย bcryptjs

## ปัญหาที่พบและวิธีการแก้ไข
**ปัญหา 1: npm ci ล้มเหลวตอน docker compose up --build**
เกิดจากไม่มีไฟล์ package-lock.json ใน auth-service
แก้โดยรัน npm install ใน auth-service ก่อน build เพื่อสร้าง package-lock.json
จากนั้น docker compose up --build ผ่านทันที

**ปัญหา 2: Browser แจ้งเตือน Your connection is not private**
เกิดจากใช้ self-signed certificate ซึ่ง browser ไม่ไว้วางใจ
แก้โดยกด Advanced → Proceed to localhost (unsafe)
เพราะในงานนี้เป็น development environment ไม่ใช่ production

## สิ่งที่ได้เรียนรู้จากงานนี้
- เข้าใจ TLS termination ที่ Nginx หมายความว่า request จาก browser
  เข้ามาเป็น HTTPS แต่ภายใน Docker network ส่งต่อเป็น HTTP ธรรมดา
- เข้าใจว่า JWT ประกอบด้วย Header, Payload, Signature โดย Payload
  อ่านได้โดยไม่ต้องมี secret แต่แก้ไขไม่ได้เพราะ Signature จะผิด
- เข้าใจ bcrypt hash ว่าแต่ละครั้งที่ hash จะได้ค่าต่างกัน แต่ compare ผ่านได้
  เพราะ salt ถูกเก็บรวมอยู่ใน hash แล้ว
- เข้าใจ trade-off ของ shared database ว่าสะดวกในการพัฒนา
  แต่ไม่ scale ได้ดีเมื่อต้องการแยก service อย่างสมบูรณ์

## แนวทางการพัฒนาต่อไปใน Set 2
- แยก database ออกเป็น database-per-service เพื่อให้แต่ละ service
  เป็นอิสระจากกันอย่างแท้จริง
- เพิ่ม Register endpoint ใน auth-service สำหรับสร้าง user ใหม่
- เปลี่ยน self-signed certificate เป็น Let's Encrypt หรือใช้ certificate
  จาก cloud provider เมื่อ deploy บน Railway
- เพิ่ม refresh token mechanism เพื่อยืดอายุการใช้งานโดยไม่ต้อง login ใหม่

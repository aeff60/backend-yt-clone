const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');

const app = express();
dotenv.config();
app.use(bodyParser.json());

// กำหนดค่าสำหรับการเชื่อมต่อกับ MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'passw@rd4demo',
  database: 'youtubedb',
  port: 3306,
});

// เปิดให้ Express ใช้งาน CORS
app.use(cors());

// เรียกใช้งานการเชื่อมต่อกับ MySQL
db.connect(err => {
  if (err) {
    console.error('ไม่สามารถเชื่อมต่อกับ MySQL:', err);
  } else {
    console.log('เชื่อมต่อกับ MySQL สำเร็จ');
  }
});

// สร้าง API endpoint สำหรับดึงข้อมูล videos
app.get('/', (req, res) => {
  const query = `
    SELECT v.video_id, v.title, v.created_at, v.thumbnail_url,
           c.name AS channel_name, c.profile_picture_url,
           p.view_count
    FROM videos v
    JOIN channels c ON v.channel_id = c.channel_id
    JOIN popular p ON v.video_id = p.video_id
  `;

  db.query(query, (err, result) => {
    if (err) {
      console.error('เกิดข้อผิดพลาดในการดึงข้อมูล:', err);
      res.status(500).send('เกิดข้อผิดพลาดในการดึงข้อมูล');
    } else {
      res.json(result);
    }
  });
});


// ให้ Express ทำงานบน port ที่กำหนด
const port = 3000;
app.listen(port, () => {
  console.log(`Server is running on port http://localhost:${port}`);
});
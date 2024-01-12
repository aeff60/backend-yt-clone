const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');

const app = express();
dotenv.config();
// app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

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


//api for search result
app.get('/result', (req, res) => {
  const { search_query } = req.query;

  const query = `
    SELECT v.video_id, v.title, v.created_at, v.thumbnail_url,
           c.name AS channel_name, c.profile_picture_url,
           p.view_count
    FROM videos v
    JOIN channels c ON v.channel_id = c.channel_id
    JOIN popular p ON v.video_id = p.video_id
    WHERE v.title LIKE ? OR c.name LIKE ?;
  `;

  db.query(query, [`%${search_query}%`, `%${search_query}%`], (err, result) => {
    if (err) {
      console.error('เกิดข้อผิดพลาดในการค้นหา:', err);
      res.status(500).send('เกิดข้อผิดพลาดในการค้นหา');
    } else {
      res.json(result);
    }
  });
});

//api for get video by with query id 
// like http://localost:3000/watch?v=1
app.get('/watch', (req, res) => {
  console.log(req.query);
  const { v } = req.query;
    // Check if v is defined
  if (!v) {
    res.status(400).send('Invalid video parameter');
    return;
  }

  const query = `
    SELECT
      v.video_id,
      v.title,
      v.description,
      v.duration,
      v.video_type,
      v.resolution,
      v.thumbnail_url,
      v.video_url,
      v.created_at,
      c.name AS channel_name,
      c.profile_picture_url,
      p.view_count,
      p.like_count,
      (SELECT COUNT(*) FROM channel_subscriptions WHERE channel_id = v.channel_id AND user_id = ?) AS is_subscribed,
      (
        SELECT GROUP_CONCAT(CONCAT(u.username, ': ', co.content) ORDER BY co.created_at SEPARATOR '\n')
        FROM comments co
        JOIN users u ON co.user_id = u.user_id
        WHERE co.video_id = v.video_id
      ) AS comments
      
    FROM videos v
    JOIN channels c ON v.channel_id = c.channel_id
    JOIN popular p ON v.video_id = p.video_id
    WHERE v.video_id = ?;
  `;

  db.query(query, [v, v], (err, result) => {
    if (err) {
      console.error('เกิดข้อผิดพลาดในการค้นหา:', err);
      res.status(500).send('เกิดข้อผิดพลาดในการค้นหา');
    } else {
      const video = result[0];
      const comments = video.comments.split('\n').map(comment => {
        const [username, content] = comment.split(': ');
        return { [username]: { content } };
      });
      video.comments = comments;
      res.json([video]);
    }
  });
});



// ให้ Express ทำงานบน port ที่กำหนด
const port = 3000;
app.listen(port, () => {
  console.log(`Server is running on port http://localhost:${port}`);
});
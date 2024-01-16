const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const dotenv = require('dotenv');
const bodyParser = require('body-parser');
const { swaggerSpec, swaggerUi } = require('./swagger');

const app = express();
dotenv.config();
// app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// กำหนดค่าสำหรับการเชื่อมต่อกับ MySQL
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  port: process.env.DB_PORT,
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

// Serve Swagger UI
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// สร้าง API endpoint สำหรับดึงข้อมูล videos
/**
 * @swagger
 * /:
 *   get:
 *     summary: Retrieve a list of videos.
 *     responses:
 *       '200':
 *         description: A JSON array of videos.
 */
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
/**
 * @swagger
 * /result:
 *   get:
 *     summary: Search for videos based on a query.
 *     parameters:
 *       - name: search_query
 *         in: query
 *         required: true
 *         description: The search query.
 *         schema:
 *           type: string
 *     responses:
 *       '200':
 *         description: A JSON array of videos.
 */
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
//api for get video by with query id
/**
 * @swagger
 * /watch:
 *   get:
 *     summary: Retrieve details of a specific video.
 *     parameters:
 *       - name: v
 *         in: query
 *         required: true
 *         description: The video ID.
 *         schema:
 *           type: string
 *     responses:
 *       '200':
 *         description: A JSON array containing details of the video.
 */
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

// like http://localost:3000/user?user_id=1

/**
 *  @swagger
 * /user:
 *  get:
 *    summary: Retrieve details of a specific user.
 *    parameters:
 *      - name: user_id
 *        in: query
 *        required: true
 *        description: The user ID.
 *        schema:
 *          type: string
 *    responses:
 *      '200':
 *        description: A JSON array containing details of the user.
 */
  

app.get('/user', (req, res) => {
  const { user_id } = req.query;
  // Check if user_id is defined
  if (!user_id) {
    res.status(400).send('Invalid user_id parameter');
    return;
  }

  const query = `
    SELECT
      u.username,
      u.profile_picture_url,
      (SELECT COUNT(*) FROM channel_subscriptions WHERE channel_id = c_sub.channel_id AND user_id = ?) AS is_subscribed,
      (SELECT COUNT(*) FROM channel_subscriptions WHERE channel_id = c_sub.channel_id) AS subscriber_count
    FROM channel_subscriptions c_sub
    JOIN users u ON c_sub.user_id = u.user_id
    WHERE c_sub.user_id = ?;
  `;

  db.query(query, [user_id, user_id], (err, result) => {
    if (err) {
      console.error('เกิดข้อผิดพลาดในการค้นหา:', err);
      res.status(500).send('เกิดข้อผิดพลาดในการค้นหา');
    } else {
      res.json(result);
    }
  });
});

//api for post user info to database
/**
 * @swagger
 * /user:
 *   post:
 *     summary: Create a new user.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *              username:
 *                type: string
 *              password:
 *                type: string
 *              profile_picture_url:
 *                type: string
 *     responses:
 *       '200':
 *         description: A JSON array of users.
 */
//api for post user info to database
app.post('/user', (req, res) => {
  const { username, password, email, first_name, last_name, profile_picture_url } = req.body;

  if (!username) {
    res.status(400).send('Username is required');
    return;
  }

  const query = `
    INSERT INTO users (username, password, email, first_name, last_name, created_at, updated_at, profile_picture_url)
    VALUES (?, ?, ?, ?, ?, NOW(), NOW(), ?);
  `;

  db.query(query, [username, password, email, first_name, last_name, profile_picture_url], (err, result) => {
    if (err) {
      console.error('เกิดข้อผิดพลาดในการสร้างผู้ใช้:', err);
      res.status(500).send('เกิดข้อผิดพลาดในการสร้างผู้ใช้');
    } else {
      res.send('สร้างผู้ใช้เรียบร้อยแล้ว');
    }
  });
});

// ให้ Express ทำงานบน port ที่กำหนด
const port = 3000;
app.listen(port, () => {
  console.log(`Server is running on port http://localhost:${port}`);
});
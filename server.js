const express = require('express');
const bodyParser = require('body-parser');
const multer = require('multer');
const path = require('path');
const methodOverride = require('method-override');

const app = express();
const PORT = process.env.PORT || 8080;

// In-memory storage for blog posts
let posts = [];
let postIdCounter = 1;

// Configure Multer for image uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ 
  storage: storage,
  fileFilter: function (req, file, cb) {
    const filetypes = /jpeg|jpg|png|gif/;
    const mimetype = filetypes.test(file.mimetype);
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    
    if (mimetype && extname) {
      return cb(null, true);
    }
    cb(new Error('Only image files are allowed!'));
  },
  limits: { fileSize: 5 * 1024 * 1024 } // 5MB limit
});

// Middleware
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(methodOverride('_method'));

// Routes
app.get('/', (req, res) => {
  res.render('home', { posts: posts });
});

app.get('/posts', (req, res) => {
  res.render('all-posts', { posts: posts });
});

app.get('/about', (req, res) => {
  res.render('about');
});

app.get('/contact', (req, res) => {
  res.render('contact');
});

app.get('/post/:id', (req, res) => {
  const post = posts.find(p => p.id === parseInt(req.params.id));
  if (post) {
    res.render('post-detail', { post: post });
  } else {
    res.status(404).send('Post not found');
  }
});

app.post('/create-post', upload.single('image'), (req, res) => {
  const { title, content } = req.body;
  
  if (title && content) {
    const newPost = {
      id: postIdCounter++,
      title: title,
      content: content,
      image: req.file ? `/uploads/${req.file.filename}` : null,
      date: new Date().toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
      })
    };
    posts.unshift(newPost);
  }
  
  res.redirect('/');
});

app.delete('/post/:id', (req, res) => {
  const postId = parseInt(req.params.id);
  posts = posts.filter(p => p.id !== postId);
  res.redirect('/posts');
});

// Create uploads directory if it doesn't exist
const fs = require('fs');
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir);
}

// Start server
app.listen(PORT, () => {
  console.log(`African Griot Blog is running on port ${PORT}`);
});

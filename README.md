# African Griot Blog

A modern blogging platform built with Express.js, EJS, and Multer. Inspired by the traditional African storytellers (griots), this application allows users to create, view, and manage blog posts with image uploads.

## Features

- 📝 Create blog posts with titles, content, and images
- 🖼️ Image upload support with Multer
- 📱 Responsive design
- 🗑️ Delete posts functionality
- 🎨 Clean and modern UI
- 🐳 Docker support for easy deployment

## Technology Stack

- **Backend**: Node.js, Express.js
- **Frontend**: EJS (Embedded JavaScript Templates)
- **File Upload**: Multer
- **Styling**: Custom CSS
- **Deployment**: Docker, Google Cloud Run

## Prerequisites

- Node.js (v18 or higher)
- npm or yarn
- Docker (for containerized deployment)

## Local Development

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd africangriot
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm run dev
```

4. Open your browser and navigate to:
```
http://localhost:8080
```

## Docker Deployment

### Build the Docker image:
```bash
docker build -t africangriot .
```

### Run the container locally:
```bash
docker run -p 8080:8080 africangriot
```

## Google Cloud Run Deployment

### Prerequisites
- Google Cloud SDK installed
- Google Cloud project created
- Billing enabled on your project

### Deployment Steps

1. Authenticate with Google Cloud:
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

2. Build and push the image to Google Container Registry:
```bash
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/africangriot
```

3. Deploy to Cloud Run:
```bash
gcloud run deploy africangriot \
  --image gcr.io/YOUR_PROJECT_ID/africangriot \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 512Mi
```

4. Your application will be deployed and you'll receive a URL to access it.

## Project Structure

```
africangriot/
├── public/
│   └── css/
│       └── style.css
├── views/
│   ├── home.ejs
│   ├── all-posts.ejs
│   ├── post-detail.ejs
│   ├── about.ejs
│   └── contact.ejs
├── uploads/           # User uploaded images
├── server.js          # Main application file
├── package.json
├── Dockerfile
├── .dockerignore
└── README.md
```

## Features in Detail

### Home Page
- Create new blog posts with title, content, and optional image
- View recent posts (up to 6)
- Clean card-based layout

### All Posts Page
- View all blog posts
- Delete posts functionality
- Full post preview with images

### Post Detail Page
- View complete post content
- Full-size images
- Delete post option

### About Page
- Information about the platform
- Mission and vision

### Contact Page
- Contact information
- Contact form (frontend only)

## Environment Variables

The application uses the following environment variables:

- `PORT`: Server port (default: 8080)
- `NODE_ENV`: Environment mode (production/development)

## Notes

- Posts are stored in memory and will be lost when the server restarts
- For production use, consider implementing a database (MongoDB, PostgreSQL, etc.)
- Uploaded images are stored in the `uploads/` directory
- For persistent storage on Google Cloud Run, consider using Google Cloud Storage

## Future Enhancements

- Add database integration for persistent storage
- Implement user authentication
- Add post editing functionality
- Integrate Google Cloud Storage for images
- Add pagination for posts
- Implement search functionality
- Add categories and tags

## License

ISC

## Author

Your Name

---

Made with ❤️ inspired by African Griots

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
- **Infrastructure as Code**: Terraform

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
- Terraform installed (optional, for infrastructure management)

### Option 1: Quick Deploy (Without Terraform)

1. Authenticate with Google Cloud:
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

2. Deploy directly from source:
```bash
gcloud run deploy africangriot \
  --source . \
  --platform managed \
  --region europe-west1 \
  --allow-unauthenticated \
  --memory 512Mi
```

3. Your application will be deployed and you'll receive a URL to access it.

### Option 2: Deploy with Terraform (Recommended for Production)

Terraform allows you to manage your infrastructure as code for reproducible deployments.

1. Navigate to the terraform directory:
```bash
cd terraform
```

2. Initialize Terraform:
```bash
terraform init
```

3. (Optional) If you have an existing deployment, import it:
```bash
terraform import google_cloud_run_service.africangriot projects/YOUR_PROJECT_ID/locations/europe-west1/services/africangriot
```

4. Review the planned changes:
```bash
terraform plan
```

5. Apply the configuration:
```bash
terraform apply
```

6. Terraform will output the service URL and other important information.

For detailed Terraform documentation, see [terraform/README.md](terraform/README.md).

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
├── terraform/         # Terraform infrastructure configuration
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   └── README.md
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

## Infrastructure Management with Terraform

This project includes Terraform configuration for managing Google Cloud infrastructure:

- **Cloud Run Service**: Container hosting with auto-scaling
- **Artifact Registry**: Docker image repository
- **Cloud Storage**: Bucket for future persistent uploads
- **Cloud Build**: CI/CD trigger for automated deployments
- **IAM Policies**: Security and access management

See [terraform/README.md](terraform/README.md) for detailed setup instructions.

## Notes

- **Storage**: Posts are stored in memory and will be lost when the server restarts (ephemeral)
- **Uploads**: Images are stored temporarily in the `uploads/` directory
- **Production**: For persistent data, consider:
  - Adding a database (MongoDB, PostgreSQL, etc.) for posts
  - Using Google Cloud Storage for image uploads (GCS bucket already configured in Terraform)
- **Scaling**: Current configuration uses min/max 1 instance for cost optimization

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

Emmanuel Gopeh

---

Made with ❤️ inspired by African Griots

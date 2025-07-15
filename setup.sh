#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_status "🚀 Starting project setup..."

# Check if Node.js is installed
if ! command_exists node; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
else
    print_success "Node.js found: $(node --version)"
fi

# Check if npm is installed
if ! command_exists npm; then
    print_error "npm is not installed. Please install npm first."
    exit 1
else
    print_success "npm found: $(npm --version)"
fi

# Install dependencies
print_status "📦 Installing dependencies..."
if npm install; then
    print_success "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Setup environment file
if [ ! -f ".env" ]; then
    print_status "🔧 Setting up environment file..."
    if cp env.example .env; then
        print_success "Environment file created from env.example"
        print_warning "Please update the .env file with your actual database credentials and secrets"
    else
        print_error "Failed to create .env file"
        exit 1
    fi
else
    print_warning ".env file already exists, skipping creation"
fi

# Generate Prisma client
print_status "🔍 Generating Prisma client..."
if npm run db:generate; then
    print_success "Prisma client generated successfully"
else
    print_error "Failed to generate Prisma client"
    exit 1
fi

# Database setup options
print_status "🗄️  Setting up database..."
print_warning "Make sure your PostgreSQL database is running and accessible via the DATABASE_URL in .env"

echo
print_status "Choose your database setup method:"
echo "  1) Docker Compose - Start PostgreSQL with Docker (recommended)"
echo "  2) db:push        - Quick schema sync (no migration files)"
echo "  3) db:migrate     - Create migration files (for team development)"
echo "  4) Skip database setup"
echo

read -p "Enter your choice (1/2/3/4): " -n 1 -r
echo

case $REPLY in
    1)
        print_status "Starting PostgreSQL with Docker Compose..."
        
        # Check if Docker is available
        if ! command_exists docker; then
            print_error "Docker is not installed. Please install Docker first."
            print_warning "You can download Docker from: https://www.docker.com/products/docker-desktop"
            exit 1
        fi
        
        if npm run db:up; then
            print_success "PostgreSQL container started successfully!"
            print_status "Waiting for PostgreSQL to be ready..."
            sleep 5
            
            # Push schema to database
            if npm run db:push; then
                print_success "Database schema pushed successfully"
            else
                print_warning "Failed to push schema. Database might still be starting up."
                print_warning "Try running 'npm run db:push' manually in a few seconds."
            fi
        else
            print_error "Failed to start PostgreSQL container"
            print_warning "Make sure Docker is running and try again"
        fi
        ;;
    2)
        print_status "Using db:push for quick schema sync..."
        if npm run db:push; then
            print_success "Database schema pushed successfully"
        else
            print_error "Failed to push database schema"
            print_warning "Please check your database connection and try running 'npm run db:push' manually"
        fi
        ;;
    3)
        print_status "Using migrate dev for development migrations..."
        if npm run db:migrate; then
            print_success "Database migrations created and applied successfully"
        else
            print_error "Failed to run database migrations"
            print_warning "Please check your database connection and try running 'npm run db:migrate' manually"
        fi
        ;;
    4)
        print_warning "Skipping database setup. You can run these commands later:"
        print_warning "  - npm run db:up (start PostgreSQL with Docker)"
        print_warning "  - npm run db:push (sync schema)"
        print_warning "  - npm run db:migrate (create migrations)"
        ;;
    *)
        print_warning "Invalid choice. Skipping database setup."
        ;;
esac

# Ask about seeding if database setup was successful
if [[ $REPLY =~ ^[123]$ ]]; then
    echo
    read -p "Do you want to seed the database with initial data? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if npm run db:seed; then
            print_success "Database seeded successfully"
        else
            print_warning "Database seeding failed or no seed script available"
        fi
    fi
fi

print_status "🎨 Project setup completed!"
echo
print_success "Next steps:"
echo "  1. Update your .env file with correct database credentials"
echo "  2. If you skipped it, run: npm run db:push"
echo "  3. Start the development server: npm run dev"
echo
print_status "Available scripts:"
echo "  - npm run dev           # Start development server"
echo "  - npm run build         # Build for production"
echo "  - npm run start         # Start production server"
echo "  - npm run lint          # Run ESLint"
echo "  - npm run test          # Run tests"
echo ""
print_status "Database commands (Docker Compose PostgreSQL):"
echo "  - npm run db:up         # Start PostgreSQL container"
echo "  - npm run db:down       # Stop PostgreSQL container"
echo "  - npm run db:studio     # Open Prisma Studio"
echo "  - npm run db:push       # Push schema to database"
echo "  - npm run db:migrate    # Run database migrations"
echo "  - npm run db:seed       # Seed database with initial data"
echo
print_success "Happy coding! 🎉" 
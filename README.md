# Next.js Template with Authentication

A modern, production-ready Next.js template featuring authentication, database integration, and a beautiful UI built with Chakra UI and Tailwind CSS.

## 🚀 Features

- **⚡ Next.js 15** - Latest version with App Router
- **🔐 Authentication** - NextAuth.js with OAuth (GitHub, Google) and email/password
- **💾 Database** - PostgreSQL with Prisma ORM
- **🎨 UI Components** - Chakra UI v3 with Tailwind CSS v4
- **🌙 Theme Support** - Light/dark mode with next-themes
- **📱 Responsive Design** - Mobile-first approach
- **🎭 Animations** - Framer Motion for smooth transitions
- **🔧 Developer Experience** - TypeScript, ESLint, Prettier
- **🧪 Testing** - Vitest with React Testing Library and coverage reports
- **🚀 CI/CD** - GitHub Actions for automated testing on pull requests
- **🐳 Docker Support** - Container setup with docker-compose

## 🛠️ Tech Stack

- **Framework**: Next.js 15 with App Router
- **Language**: TypeScript
- **Database**: PostgreSQL with Prisma ORM
- **Authentication**: NextAuth.js
- **Styling**: Chakra UI v3 + Tailwind CSS v4
- **Typography**: Outfit Google Font
- **Animations**: Framer Motion
- **Icons**: React Icons
- **Testing**: Vitest + React Testing Library
- **CI/CD**: GitHub Actions
- **Code Quality**: ESLint + Prettier + lint-staged

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- PostgreSQL database (or Docker for automatic setup)
- Git

### Option 1: Automated Setup (Recommended)

Use our automated setup script for the fastest way to get started:

```bash
git clone <your-repo-url>
cd base-nextjs-template
./setup.sh
```

The setup script will:

- ✅ Check Docker and Docker Compose prerequisites
- ✅ Create `.env` file from template
- ✅ Start PostgreSQL with Docker Compose
- ✅ Install npm dependencies
- ✅ Generate Prisma client
- ✅ Set up database schema
- ✅ Seed database with sample data (including admin user)

### Option 2: Manual Setup

If you prefer to set up manually or need custom configuration:

#### 1. Clone and Install

```bash
git clone <your-repo-url>
cd base-nextjs-template
npm install
```

#### 2. Environment Setup

Copy the environment template and configure your variables:

```bash
cp env.example .env
```

The `.env` file will contain:

```env
# Database
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/postgres?schema=public"

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-secret-key-here-replace-in-production"

# Admin credentials (for seeding)
ADMIN_EMAIL="admin@admin.com"
ADMIN_PASSWORD="admin123"

# OAuth providers (optional)
# GITHUB_ID="your-github-client-id"
# GITHUB_SECRET="your-github-client-secret"
# GOOGLE_ID="your-google-client-id"
# GOOGLE_SECRET="your-google-client-secret"
```

#### 3. Database Setup

```bash
# Start PostgreSQL with Docker
docker compose up -d postgres

# Generate Prisma client
npm run db:generate

# Set up database schema
npm run db:push

# (Optional) Seed the database
npm run db:seed
```

#### 4. Start Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### 🔐 Default Admin Credentials

After running the setup script, you can log in with the default admin account:

- **Email**: `admin@admin.com`
- **Password**: `admin123`

> **Note**: Change these credentials in production by updating the `ADMIN_EMAIL` and `ADMIN_PASSWORD` environment variables.

## 📁 Project Structure

```
src/
├── app/                    # Next.js App Router pages
│   ├── api/               # API routes
│   │   └── auth/          # Authentication endpoints
│   └── auth/              # Authentication pages
├── components/            # Reusable components
│   ├── auth/              # Authentication components
│   ├── providers/         # Context providers
│   ├── site/              # Site layout components
│   └── ui/                # UI components
├── lib/                   # Utility libraries
└── types/                 # TypeScript type definitions
```

## 🔐 Authentication

This template includes a complete authentication system with:

- **OAuth Providers**: GitHub, Google (easily extensible)
- **Email/Password**: Traditional authentication with secure password hashing
- **Session Management**: Database-backed sessions with NextAuth.js
- **Protected Routes**: Server and client-side protection

### OAuth Setup

See [AUTH_SETUP.md](./AUTH_SETUP.md) for detailed OAuth configuration instructions.

### Usage Examples

```tsx
// Client-side authentication
import { useSession } from 'next-auth/react'

export function MyComponent() {
  const { data: session, status } = useSession()

  if (status === 'loading') return <div>Loading...</div>
  if (!session) return <div>Please sign in</div>

  return <div>Welcome {session.user?.name}!</div>
}
```

```tsx
// Server-side authentication
import { getServerSession } from 'next-auth/next'
import { authOptions } from '@/lib/auth'

export default async function Page() {
  const session = await getServerSession(authOptions)

  if (!session) {
    return <div>Access denied</div>
  }

  return <div>Protected content</div>
}
```

## 🎨 UI Components

Built with Chakra UI v3 and Tailwind CSS v4:

- **Design System**: Consistent spacing, colors, and typography with Outfit font
- **Responsive**: Mobile-first responsive design
- **Accessible**: ARIA compliant components
- **Themeable**: Easy customization and branding
- **Dark Mode**: Built-in light/dark theme support
- **Typography**: Clean, modern Outfit Google Font

## 🔧 Code Quality & Git Hooks

This project uses **lint-staged** with **Husky** to ensure code quality before commits:

- **Pre-commit Hook**: Automatically runs ESLint and Prettier on staged files
- **Lint-staged Configuration**: Only processes files that are staged for commit
- **Automatic Fixing**: ESLint will attempt to fix issues automatically
- **Consistent Formatting**: Prettier ensures consistent code style

### Git Hooks

The following git hooks are configured:

- **pre-commit**: Runs `lint-staged` to check and fix code before committing

### Manual Usage

You can also run lint-staged manually:

```bash
npm run lint-staged  # Run linters on staged files
```

## 🧪 Testing

This project uses Vitest for fast and reliable testing:

- **Unit Tests**: Test individual components and functions
- **Integration Tests**: Test component interactions
- **Coverage Reports**: Track test coverage with detailed reports
- **Watch Mode**: Automatic test re-runs during development
- **UI Mode**: Interactive test runner with web interface

### Writing Tests

Create test files with `.test.tsx` or `.test.ts` extensions:

```tsx
// src/components/__tests__/Button.test.tsx
import { render, screen } from '@testing-library/react'
import { describe, it, expect } from 'vitest'
import { Button } from '../Button'

describe('Button', () => {
  it('renders button with text', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByRole('button')).toHaveTextContent('Click me')
  })
})
```

### Testing Features

- **React Testing Library**: Test components the way users interact with them
- **Vitest**: Fast test runner with Jest-compatible API
- **Coverage Reports**: Built-in coverage analysis
- **Mocking**: Pre-configured mocks for Next.js, NextAuth, and Framer Motion
- **Setup**: Global test setup with custom matchers and utilities
- **CI/CD Integration**: Automated testing on pull requests

## 🚀 CI/CD

This project includes multiple GitHub Actions workflows for continuous integration:

### Simple Test Workflow (Recommended)

- **File**: `.github/workflows/simple-test.yml`
- **Triggers**: Pull requests and pushes to `main` and `develop` branches
- **Actions**: Linting, formatting, tests, and coverage
- **Reliable**: No external dependencies or artifact uploads

### Test Workflow

- **File**: `.github/workflows/test.yml`
- **Triggers**: Pull requests to `main` and `develop` branches
- **Actions**: Runs Vitest tests with coverage reporting
- **Artifacts**: Attempts to upload coverage reports (with fallback)
- **Node.js**: Tests against Node.js 18 with npm caching

### Comprehensive CI Workflow

- **File**: `.github/workflows/ci.yml`
- **Linting**: ESLint code quality checks
- **Formatting**: Prettier code formatting verification
- **Testing**: Full test suite with coverage
- **Building**: Verifies successful production build
- **Artifacts**: Uploads build and coverage artifacts (with error handling)

### Testing GitHub Actions Locally

You can test GitHub Actions workflows locally using `act`:

#### Installation

```bash
# macOS (using Homebrew)
brew install act

# Other platforms: https://github.com/nektos/act#installation
```

#### Usage

```bash
# Test the simple workflow (recommended)
act pull_request -W .github/workflows/simple-test.yml

# Test the main CI workflow
act pull_request -W .github/workflows/ci.yml

# Test the test-only workflow
act pull_request -W .github/workflows/test.yml

# List all available workflows
act -l

# Run with verbose output
act pull_request -W .github/workflows/simple-test.yml -v
```

#### Important Notes

- **Docker Required**: `act` uses Docker to simulate GitHub runners
- **Environment Variables**: Create `.env` file for secrets if needed
- **Artifact Uploads**: May not work locally (hence our simple workflow)
- **Resource Usage**: Can be resource-intensive for complex workflows

#### Recommended Workflow for Testing

1. **Test locally first**: `act pull_request -W .github/workflows/simple-test.yml`
2. **Fix any issues**: Update code and re-test
3. **Push to GitHub**: Let the real workflows run
4. **Use simple workflow**: Most reliable for both local and remote testing

#### Quick Start (if you have act installed)

```bash
# Check if act is installed
act --version

# Test the simple workflow immediately
act pull_request -W .github/workflows/simple-test.yml

# If you get Docker permission errors, you might need:
# sudo docker ps  # or configure Docker for non-root users
```

## 🔧 Development

### Available Scripts

```bash
# Development
npm run dev          # Start development server
npm run build        # Build for production
npm run start        # Start production server

# Code Quality
npm run lint         # Run ESLint
npm run format       # Format code with Prettier
npm run format:check # Check code formatting
npm run lint-staged  # Run linters on staged files

# Testing
npm run test         # Run tests in watch mode
npm run test:run     # Run tests once
npm run test:ui      # Run tests with UI
npm run test:coverage # Run tests with coverage

# Database
npm run db:generate  # Generate Prisma client
npm run db:push      # Push schema changes to database
npm run db:migrate   # Run database migrations
npm run db:seed      # Seed database with sample data
npm run db:studio    # Open Prisma Studio
```

### GitHub Actions Testing

```bash
# Install act (macOS)
brew install act

# Test workflows locally
act pull_request -W .github/workflows/simple-test.yml
act pull_request -W .github/workflows/ci.yml
act -l  # List all workflows
```

### Database Commands

```bash
npm run db:studio    # Open Prisma Studio
npm run db:generate  # Generate Prisma client
npm run db:migrate   # Run migrations
npm run db:push      # Push schema changes
npm run db:seed      # Seed database
```

### Docker Development

```bash
# Start with Docker Compose
docker compose up -d

# Stop services
docker compose down
```

## 🌐 Deployment

### Environment Variables

Ensure these are set in your production environment:

- `DATABASE_URL` - PostgreSQL connection string
- `NEXTAUTH_URL` - Your deployed app URL
- `NEXTAUTH_SECRET` - Strong secret key
- OAuth credentials (if using OAuth)

### Recommended Platforms

- **Vercel** - Seamless Next.js deployment
- **Railway** - Full-stack deployment with database
- **Netlify** - Static site deployment
- **Docker** - Container deployment anywhere

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details on:

- Development workflow
- Code standards
- Testing requirements
- Pull request process

Quick start:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Run tests (`npm run test:run`)
4. Commit your changes (`git commit -m 'feat: add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📖 [Next.js Documentation](https://nextjs.org/docs)
- 🔐 [NextAuth.js Documentation](https://next-auth.js.org)
- 🗄️ [Prisma Documentation](https://prisma.io/docs)
- 🎨 [Chakra UI Documentation](https://chakra-ui.com)

---

Built with ❤️ using Next.js

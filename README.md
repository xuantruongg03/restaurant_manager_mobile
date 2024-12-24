# Restaurant Manager Mobile

A Flutter mobile application for restaurant management with comprehensive features for both restaurant owners and staff.

## Overview

This application is built using Flutter and follows a clean architecture pattern with GetX for state management. It provides a complete solution for managing various aspects of a restaurant including menu management, table management, order processing, and staff management.

## Key Features

### Authentication & User Management
- Secure login/signup system with phone verification
- Profile management with avatar upload capability
- Role-based access control (Restaurant Owner/Staff)

### Menu Management
- Create and manage multiple menus
- Add/Edit/Delete food items with images
- Categorize food items
- QR code generation for menu access

### Table Management
- Real-time table status monitoring
- Table merging capabilities
- Order management per table
- QR code generation for table-specific menus

### Order Processing
- Real-time order notifications using WebSocket
- Order status tracking (Pending/Confirmed/Completed)
- Order modification and cancellation features

### Billing & Payments
- Generate bills per table
- Track payment status
- Order history maintenance

### Staff Management
- Staff scheduling
- Role assignment
- Performance tracking

## Technical Implementation

### Architecture
- Uses GetX for state management and dependency injection
- Implements repository pattern for data management
- Uses services for cross-cutting concerns

### Security
- Implements secure authentication using Basic Auth
- Encrypts sensitive data using AES encryption
- Secure storage for user credentials

### API Integration
- RESTful API integration using custom ApiClient
- WebSocket integration for real-time updates
- Image upload to Cloudinary

### UI/UX
- Material Design implementation
- Responsive layouts
- Custom widgets for consistent UI elements
- Support for both light and dark themes

## Getting Started

1. Clone the repository
2. Set up environment variables in `.env` file
3. Install dependencies: 
4. Run the application:
5. 

## Environment Setup

Required environment variables:
- `API_URL`: Backend API URL
- `WS_URL`: WebSocket URL
- `CLOUD_NAME`: Cloudinary cloud name
- `API_KEY`: Cloudinary API key
- `API_SECRET`: Cloudinary API secret
- `UPLOAD_PRESET`: Cloudinary upload preset

## Dependencies

Key dependencies include:
- `get`: State management and routing
- `http`: API communication
- `web_socket_channel`: Real-time communication
- `encrypt`: Data encryption
- `image_picker`: Image selection
- `phosphor_flutter`: Icon pack 
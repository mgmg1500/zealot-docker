#!/bin/bash

# Zealot Nginx Setup Script
# This script helps you configure Nginx for zealot.sonaku.vip

echo "🚀 Zealot Nginx Configuration Setup"
echo "=================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run this script as root (sudo ./setup-nginx.sh)"
    exit 1
fi

# Function to install nginx if not present
install_nginx() {
    if ! command -v nginx &> /dev/null; then
        echo "📦 Installing Nginx..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            if command -v brew &> /dev/null; then
                brew install nginx
            else
                echo "❌ Please install Homebrew first or install Nginx manually"
                exit 1
            fi
        elif [[ -f /etc/debian_version ]]; then
            # Ubuntu/Debian
            apt update
            apt install -y nginx
        elif [[ -f /etc/redhat-release ]]; then
            # CentOS/RHEL
            yum install -y nginx
        else
            echo "❌ Unsupported OS. Please install Nginx manually."
            exit 1
        fi
    else
        echo "✅ Nginx is already installed"
    fi
}

# Function to setup SSL with Let's Encrypt
setup_ssl() {
    echo "🔒 Do you want to set up SSL with Let's Encrypt? (y/n)"
    read -r ssl_choice
    
    if [[ $ssl_choice == "y" || $ssl_choice == "Y" ]]; then
        # Install certbot
        if ! command -v certbot &> /dev/null; then
            echo "📦 Installing Certbot..."
            if [[ -f /etc/debian_version ]]; then
                apt install -y certbot python3-certbot-nginx
            elif [[ -f /etc/redhat-release ]]; then
                yum install -y certbot python3-certbot-nginx
            else
                echo "❌ Please install certbot manually"
                return 1
            fi
        fi
        
        echo "📧 Enter your email for Let's Encrypt:"
        read -r email
        
        # Get certificate
        certbot --nginx -d zealot.sonaku.vip --email "$email" --agree-tos --non-interactive
        
        if [ $? -eq 0 ]; then
            echo "✅ SSL certificate installed successfully!"
            return 0
        else
            echo "❌ SSL setup failed. Using HTTP configuration."
            return 1
        fi
    fi
    return 1
}

# Main setup
main() {
    echo "🔍 Checking system..."
    
    # Install nginx if needed
    install_nginx
    
    # Create nginx directory if it doesn't exist
    mkdir -p /etc/nginx/sites-available
    mkdir -p /etc/nginx/sites-enabled
    
    # Copy configuration files
    echo "📁 Copying Nginx configuration..."
    
    # Determine which config to use
    if setup_ssl; then
        # SSL was successful, certbot probably modified the config
        echo "✅ Using SSL configuration"
    else
        # Use HTTP-only configuration
        cp "$(dirname "$0")/zealot.sonaku.vip-http.conf" /etc/nginx/sites-available/zealot.sonaku.vip
        echo "📝 Using HTTP-only configuration"
    fi
    
    # Enable site
    ln -sf /etc/nginx/sites-available/zealot.sonaku.vip /etc/nginx/sites-enabled/
    
    # Test nginx configuration
    echo "🧪 Testing Nginx configuration..."
    nginx -t
    
    if [ $? -eq 0 ]; then
        echo "✅ Nginx configuration is valid"
        
        # Reload nginx
        echo "🔄 Reloading Nginx..."
        systemctl reload nginx
        systemctl enable nginx
        
        echo ""
        echo "🎉 Setup complete!"
        echo ""
        echo "📋 Next steps:"
        echo "1. Make sure zealot.sonaku.vip points to this server's IP"
        echo "2. Ensure your Zealot Docker containers are running:"
        echo "   docker compose up -d"
        echo "3. Visit: http://zealot.sonaku.vip"
        echo ""
        echo "📊 Useful commands:"
        echo "  Check Nginx status: systemctl status nginx"
        echo "  View logs: tail -f /var/log/nginx/zealot.sonaku.vip.*.log"
        echo "  Restart Nginx: systemctl restart nginx"
        
    else
        echo "❌ Nginx configuration test failed!"
        exit 1
    fi
}

# Run main function
main
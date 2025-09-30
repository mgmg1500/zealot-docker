# Zealot - Self-Hosted Mobile App Distribution Platform

## What is Zealot?

Zealot is a **self-hosted mobile app distribution platform** that allows you to distribute mobile apps (iOS, Android, macOS, Windows, Linux) to your team, beta testers, or users without relying on public app stores or third-party services.

Think of it as your own private "App Store" that you control completely.

## Key Features

### 📱 **Multi-Platform Support**
- **Android** (.apk, .aab files)
- **iOS** (.ipa files) 
- **macOS** (.dmg, .pkg files)
- **Windows** (.exe, .msi files)
- **Linux** (.deb, .rpm, .AppImage files)

### 🚀 **Core Capabilities**
- **App Distribution**: Upload and distribute apps to team members
- **Version Management**: Track different versions of your apps
- **User Management**: Control who can access which apps
- **Download Analytics**: See who downloaded what and when
- **QR Code Generation**: Easy sharing via QR codes
- **Release Notes**: Add detailed release notes for each version
- **Notifications**: Alert users about new releases

### 🔄 **CI/CD Integration**
- **REST API**: Automate uploads from your build pipeline
- **Webhooks**: Get notified about new releases
- **CLI Tools**: Command-line integration
- **Popular CI Platforms**: Jenkins, GitHub Actions, GitLab CI, etc.

### 👥 **Team Features**
- **Role-based Access**: Admin, Developer, User roles
- **Channel Organization**: Organize apps by teams/projects
- **Guest Access**: Allow external users to download specific apps
- **Team Invitations**: Easy onboarding for new team members

## Your Installation Details

### Access Information
- **URL**: http://localhost:7373
- **Login Page**: http://localhost:7373/users/sign_in
- **Admin Email**: admin@zealot.com
- **Admin Password**: ze@l0t

### Docker Configuration
- **Web Port**: 7373 (HTTP only)
- **Direct Zealot Port**: 8081 (bypass proxy)
- **Database**: PostgreSQL (internal)
- **Web Server**: Caddy (reverse proxy)

## Common Use Cases

### 1. **Internal App Distribution**
- Distribute internal company apps to employees
- Beta testing before app store release
- Enterprise apps that don't go to public stores

### 2. **Development Team Workflow**
```
Developer → Build App → Upload to Zealot → Team Downloads → Feedback
```

### 3. **CI/CD Pipeline Integration**
```
Code Push → CI Build → Auto-upload to Zealot → Notify Team → Download & Test
```

### 4. **Client Demos**
- Share prototype apps with clients
- Controlled access to work-in-progress apps
- Easy updates without app store delays

## How to Use Your Zealot Instance

### 1. **First Login**
1. Go to http://localhost:7373
2. Login with admin@zealot.com / ze@l0t
3. Change the default password in settings

### 2. **Create Your First App**
1. Click "New App" or "+" button
2. Choose platform (iOS, Android, etc.)
3. Upload your app file (.ipa, .apk, etc.)
4. Add release notes
5. Set permissions (who can access)

### 3. **Invite Team Members**
1. Go to "Users" section
2. Click "Invite User"
3. Set their role (Admin, Developer, User)
4. They'll receive invitation email

### 4. **Share Apps**
- **QR Code**: Generate QR codes for easy mobile downloads
- **Direct Link**: Share download links
- **Email Notifications**: Automatic notifications for new releases

### 5. **Mobile Installation**
- **iOS**: Users need to trust the certificate in Settings
- **Android**: Enable "Install from Unknown Sources"

## API Integration Examples

### Upload App via API
```bash
curl -X POST http://localhost:7373/api/apps \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -F "file=@your_app.apk" \
  -F "channel_key=your_channel" \
  -F "release_notes=New version with bug fixes"
```

### Get App List
```bash
curl -X GET http://localhost:7373/api/apps \
  -H "Authorization: Bearer YOUR_API_TOKEN"
```

## Directory Structure
```
zealot-docker/
├── docker-compose.yml     # Main container configuration
├── .env                   # Environment variables & settings
├── caddy/                 # Web server configuration
│   └── etc/caddy/
│       └── Caddyfile     # HTTP server settings
├── backup/               # Backup storage
├── scripts/              # Deployment scripts
└── templates/            # Configuration templates
```

## Maintenance Commands

### Start Services
```bash
docker compose up -d
```

### Stop Services
```bash
docker compose down
```

### View Logs
```bash
# All services
docker compose logs

# Specific service
docker compose logs zealot
docker compose logs web
docker compose logs postgres
```

### Backup Data
```bash
./backup
```

### Update Zealot
```bash
./deploy
```

## Security Considerations

### 1. **Network Security**
- Currently accessible only on localhost (port 7373)
- To make externally accessible, configure domain in .env
- Use HTTPS for production (enable SSL in configuration)

### 2. **Data Security**
- All data stored locally in Docker volumes
- Regular backups recommended
- User access controls via roles

### 3. **App Security**
- iOS apps require device trust for enterprise distribution
- Android apps flagged as "unknown source"
- Consider code signing for production apps

## Troubleshooting

### Common Issues
1. **Port Conflicts**: Change port in docker-compose.yml
2. **SSL Issues**: Disable SSL with ZEALOT_FORCE_SSL=false
3. **Storage Issues**: Check Docker volume space
4. **Network Issues**: Verify container networking

### Logs Location
- Application logs: `./log/`
- Container logs: `docker compose logs [service]`

## Next Steps

1. **Configure Domain**: Set up proper domain name for external access
2. **Enable SSL**: Configure HTTPS for production use
3. **Set up CI/CD**: Integrate with your build pipeline
4. **Customize**: Modify branding and settings
5. **Backup Strategy**: Set up automated backups

## Resources

- **Official Docs**: https://zealot.ews.im/docs/
- **GitHub**: https://github.com/tryzealot/zealot
- **Demo**: https://tryzealot.ews.im/
- **Community**: https://t.me/+csa3Y2KOx44wMGRl

---

**Your Zealot instance is now ready for mobile app distribution! 🚀**
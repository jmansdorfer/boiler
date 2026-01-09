# Discord Profile Boiler Bot 🔥

A Discord bot that "boils" user profile pictures by replacing a green screen square in an animated GIF template with Discord avatars. The profile picture dynamically resizes and moves with the green square, creating a fun bobbing/dunking animation effect.

## Features

- 🎯 Slash command interface (`/boil`)
- 👤 Boil your own or others' profile pictures
- 🎬 Dynamic per-frame position and size tracking
- 🗜️ Automatic GIF compression to stay under Discord's 25MB limit
- 🐳 Docker support for easy deployment
- 📦 Uses `uv` for fast dependency management

## Quick Start with Docker (Recommended)

### Prerequisites
- Docker and Docker Compose installed
- Discord bot token
- Your `template_boiling.gif` file with a green square (`#00FF00`)

### Setup

1. **Create `.env` file:**
```bash
cp env.example .env
nano .env  # Add your bot token
```

2. **Add your template GIF** - place `template_boiling.gif` in the project directory

3. **Run:**
```bash
docker-compose up -d
```

That's it! The bot is now running.

### View logs:
```bash
docker-compose logs -f
```

### Stop the bot:
```bash
docker-compose down
```

## Manual Setup (Without Docker)

### 1. Install Dependencies
```bash
# Using uv (recommended)
pip install uv
uv pip install -e .

# Or using pip
pip install discord.py Pillow numpy
```

### 2. Configure Bot Token
```bash
# Set environment variable
export BOT_TOKEN='your_bot_token_here'

# Or edit discord_boil_bot.py directly
```

### 3. Run
```bash
python discord_boil_bot.py
```

## Discord Bot Setup

### 1. Create Bot Application
1. Go to https://discord.com/developers/applications
2. Click "New Application" and give it a name
3. Go to "Bot" tab → Click "Add Bot"
4. Copy your bot token (keep it secret!)

### 2. Enable Required Intents
In the Bot settings, enable these under "Privileged Gateway Intents":
- ✅ **PRESENCE INTENT**
- ✅ **SERVER MEMBERS INTENT**
- ✅ **MESSAGE CONTENT INTENT**

### 3. Invite Bot to Your Server
1. Go to "OAuth2" → "URL Generator"
2. Select scopes:
   - `bot`
   - `applications.commands`
3. Select permissions:
   - Send Messages
   - Attach Files
   - Use Slash Commands
4. Copy the URL and open in browser to invite

### 4. Get Your Server ID
1. Enable Developer Mode in Discord (Settings → Advanced → Developer Mode)
2. Right-click your server → Copy Server ID
3. Add it to `discord_boil_bot.py` in the `on_ready()` function (already set if you haven't changed it)

## Usage

### Commands
- `/boil` - Boil your own profile picture
- `/boil @user` - Boil someone else's profile picture

### Examples
```
/boil              → Boils your avatar
/boil @username    → Boils the mentioned user's avatar
```

## Template GIF Requirements

Your `template_boiling.gif` should have:

✅ **Pure green square**: Use exactly `#00FF00` (RGB: 0, 255, 0)  
✅ **Hard edges**: No anti-aliasing or blur on the green square  
✅ **Solid color**: No gradients or transparency  
✅ **Small file size**: Keep under 7-8 MB to ensure output stays under 25 MB  

### Tips for Optimization
- Reduce frame rate to 15 fps
- Keep resolution reasonable (not 4K)
- Use https://ezgif.com/optimize to compress
- Shorten animation duration if needed

The bot automatically:
- Detects green position per frame (works with moving squares!)
- Resizes profile pictures to match green size per frame
- Only shows the image where green pixels exist
- Compresses output with 64-color palette

## File Structure

```
discord-boil-bot/
├── discord_boil_bot.py       # Main bot script
├── template_boiling.gif      # Your GIF template
├── pyproject.toml            # Python dependencies (uv)
├── Dockerfile                # Docker configuration
├── docker-compose.yml        # Docker Compose setup
├── .env                      # Bot token (create from env.example)
├── .env.example              # Environment template
├── .dockerignore             # Docker ignore rules
├── .gitignore                # Git ignore rules
├── README.md                 # This file
├── DOCKER_SETUP.md           # Detailed Docker guide
└── temp/                     # Auto-created temp files
```

## Troubleshooting

### "Payload Too Large" (413 Error)
- Your template GIF is too large
- Optimize it at https://ezgif.com/optimize
- Target 5-7 MB for the template to ensure output < 25 MB

### Green Not Being Replaced
- Check that green is exactly `#00FF00`
- Ensure no anti-aliasing on edges
- Avoid gradients or transparency
- Check logs to see if green is detected

### Bot Not Responding
- Verify all three Privileged Gateway Intents are enabled
- Check bot has proper permissions in the channel
- Ensure `/boil` command appears when typing `/`
- Check logs: `docker-compose logs -f`

### Duplicate Commands Showing
- The bot clears old commands on startup
- Restart Discord client if duplicates persist
- Wait a few minutes for Discord's cache to refresh

### Docker Build Fails (DNS Issues)
If you're using AdGuard Home or Tailscale MagicDNS:

1. **Configure Docker DNS:**
```bash
sudo nano /etc/docker/daemon.json
```
Add:
```json
{
  "dns": ["8.8.8.8", "1.1.1.1"]
}
```

2. **Restart Docker:**
```bash
sudo systemctl restart docker
```

3. **Or whitelist in AdGuard:**
- `registry-1.docker.io`
- `pypi.org`
- `files.pythonhosted.org`

## Advanced Configuration

### Adding Multiple Servers
Edit `discord_boil_bot.py`, find the `on_ready()` function:
```python
guild_ids = [
    1414393429437321218,  # Your first server
    987654321098765432,   # Add more here
]
```

### Adjusting Compression
In `discord_boil_bot.py`, find the `save()` call:
```python
colors=64  # Reduce to 32 for smaller files (lower quality)
           # Increase to 128 for better quality (larger files)
```

### Custom Green Color Threshold
In `replace_green_square_in_gif()`, adjust detection:
```python
green_mask = (
    (frame_array[:, :, 1] > 200) &  # Green threshold
    (frame_array[:, :, 0] < 100) &  # Red threshold  
    (frame_array[:, :, 2] < 100)    # Blue threshold
)
```

## Performance Notes

- Processing takes 2-4 seconds per request
- Output GIF size: ~12-20 MB (depending on template)
- Supports up to 108 frames tested
- 64-color palette provides good quality/size balance

## Security

- **Never commit `.env`** - it's in `.gitignore` by default
- Keep your bot token secret
- Bot automatically cleans up temp files
- All processing happens server-side

## Contributing

Feel free to fork and modify! Some ideas:
- Support for custom templates per server
- Video output (MP4) instead of GIF
- More advanced green screen effects
- Template gallery/selection

## License

Free to use and modify!

---

**Need help?** Check the logs with `docker-compose logs -f` or review DOCKER_SETUP.md for detailed deployment instructions.
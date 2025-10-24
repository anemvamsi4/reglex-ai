#!/usr/bin/env python
"""
SEBI Compliance Backend Server
Startup script with proper signal handling, CORS, and graceful shutdown
"""


import sys
import os
import signal
import asyncio
from pathlib import Path

from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

load_dotenv()

# Add the src directory to Python path
backend_root = Path(__file__).parent
src_path = backend_root / "src"
sys.path.insert(0, str(backend_root))
sys.path.insert(0, str(src_path))

# Global server instance for graceful shutdown
server = None


def signal_handler(signum, frame):
    """Handle shutdown signals gracefully"""
    print(f"\n🛑 Received signal {signum}. Initiating graceful shutdown...")
    if server:
        server.should_exit = True


async def shutdown_handler():
    """Handle async shutdown"""
    print("[CLEANUP] Performing cleanup tasks...")
    await asyncio.sleep(0.2)
    print("[OK] Cleanup completed")


def main():
    """Main server startup function"""
    global server

    # Register signal handlers
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    print("[START] SEBI Compliance Backend Server")
    print(f"[PATH] Backend root: {backend_root}")
    print(f"[PATH] Source path: {src_path}")

    try:
        from src.pipeline.run_pipeline import app
        print("[OK] Successfully imported FastAPI app")

        # ✅ Add CORS middleware
        frontend_url = os.getenv(
            "FRONTEND_URL",
            "https://frontend-service-127310351608.us-central1.run.app"
        )
        app.add_middleware(
            CORSMiddleware,
            allow_origins=[frontend_url],
            allow_credentials=True,
            allow_methods=["*"],
            allow_headers=["*"],
        )
        print(f"[CORS] Enabled for origin: {frontend_url}")

        import uvicorn
        from uvicorn.config import Config

        print("[SERVER] Starting backend server...")
        print("[URL]     http://0.0.0.0:8080")
        print("[HEALTH]  http://0.0.0.0:8080/health")
        print("[UPLOAD]  http://0.0.0.0:8080/upload-pdf/")

        config = Config(
            app=app,
            host="0.0.0.0",
            port=8080,        # ✅ Cloud Run expects this port
            reload=False,
            access_log=True,
            log_level="info",
            lifespan="auto"
        )

        server = uvicorn.Server(config)

        try:
            server.run()
        except KeyboardInterrupt:
            print("\n[INTERRUPT] Keyboard interrupt received")
        except Exception as e:
            print(f"\n[ERROR] Server error: {e}")
        finally:
            print("[SHUTDOWN] Initiating shutdown sequence...")
            asyncio.run(shutdown_handler())
            print("[COMPLETE] Server shutdown complete")

    except ImportError as e:
        print(f"[ERROR] Import error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"[ERROR] Startup error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()

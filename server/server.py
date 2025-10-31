import socketio
from aiohttp import web

sio = socketio.AsyncServer(cors_allowed_origins='*')
app = web.Application()
sio.attach(app)

user_sessions = {}

@sio.event
async def connect(sid, environ):
    print(f"Client connected: {sid}")

@sio.event
async def disconnect(sid):
    user_id = user_sessions.pop(sid, None)
    print(f"User {user_id} disconnected (sid={sid})")

@sio.event
async def join_chat(sid, data):
    my_id = data["my_id"]
    other_id = data["other_id"]

    room = f"{min(my_id, other_id)}_{max(my_id, other_id)}"

    user_sessions[sid] = my_id

    await sio.enter_room(sid, room)
    print(f"User {my_id} joined room {room}")

    await sio.emit("joined_chat", {"room": room}, to=sid)

@sio.event
async def send_message(sid, data):
    sender_id = user_sessions.get(sid)
    receiver_id = data["to"]
    message = data["message"]

    if sender_id is None:
        print("Unknown sender, ignoring message")
        return

    room = f"{min(sender_id, receiver_id)}_{max(sender_id, receiver_id)}"

    msg = {"from": sender_id, "message": message}

    print(f"{sender_id} -> {receiver_id}: {message}")

    await sio.emit("receive_message", msg, room=room, skip_sid=sid)

if __name__ == "__main__":
    web.run_app(app, port=5000)

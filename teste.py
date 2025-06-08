import asyncio
from bleak import BleakClient, BleakScanner
from flask import Flask, jsonify
import random

# UUID para o serviço de frequência cardíaca
HEART_RATE_UUID = "00002a37-0000-1000-8000-00805f9b34fb"

# Inicialização do Flask
app = Flask(__name__)

def notification_handler(sender, data):
    """Manipulador de notificações para dados de frequência cardíaca"""
    heart_rate = data[1]
    print(f"Frequência cardíaca: {heart_rate} bpm")

    if heart_rate < 50:
        print("Frequência cardíaca baixa, recomendamos procurar ajuda.")
    elif heart_rate > 120:
        print("Frequência cardíaca alta, recomendamos procurar ajuda.")
    else:
        print("Frequência cardíaca normal.")

async def scan_devices():
    """Função para escanear dispositivos Bluetooth"""
    print("Procurando dispositivos bluetooth...")
    devices = await BleakScanner.discover()
    for i, device in enumerate(devices):
        print(f"{i}: {device.name} - {device.address}")
    return devices

async def connect_to_device(address):
    """Função para conectar ao dispositivo Bluetooth"""
    async with BleakClient(address) as client:
        print("Conectado")
        await client.start_notify(HEART_RATE_UUID, notification_handler)
        print("Lendo frequência cardíaca...")
        while True:
            await asyncio.sleep(5)

async def main():
    """Função principal para o Bluetooth"""
    devices = await scan_devices()
    device_index = int(input("Digite o número do dispositivo que deseja conectar: "))
    address = devices[device_index].address
    await connect_to_device(address)


@app.route('/frequencia')
def get_frequencia():
    """Endpoint para obter frequência cardíaca simulada"""
    fake_hr = random.randint(50, 130)
    return jsonify({'bpm': fake_hr})

if __name__ == '__main__':
    
    import threading
    flask_thread = threading.Thread(target=lambda: app.run(host='0.0.0.0', port=5000))
    flask_thread.daemon = True
    flask_thread.start()
    
   
    asyncio.run(main())
import socket
import os

# 设置服务器的IP地址和端口
SERVER_IP = '192.168.109.131'
SERVER_PORT = 12345
BUFFER_SIZE = 1024  # 发送数据的缓冲区大小

def send_file(file_path):
    # 检查文件是否存在
    if not os.path.isfile(file_path):
        print("File does not exist！")
        return

    # 创建UDP socket
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    # 获取文件名并发送给服务器
    file_name = os.path.basename(file_path)
    client_socket.sendto(file_name.encode(), (SERVER_IP, SERVER_PORT))

    # 发送文件内容
    with open(file_path, 'rb') as f:
        while True:
            data = f.read(BUFFER_SIZE)
            if not data:
                break  # 如果文件数据读取完毕，退出

            client_socket.sendto(data, (SERVER_IP, SERVER_PORT))

    print(f"文件 {file_name} Successfully send.")

    # 关闭socket
    client_socket.close()

if __name__ == "__main__":
    file_path = "D:/x.txt"  # 需要发送的文件路径
    send_file(file_path)
import socket
import os

# 设置服务器的IP地址和端口
SERVER_IP = '192.168.109.131'  # 你可以根据实际情况修改
SERVER_PORT = 12345            # 服务器监听的端口
BUFFER_SIZE = 1024             # 接收数据的缓冲区大小
SAVE_DIR = 'received_files'    # 保存文件的目录
file_name='x.txt'

def receive_file():
    # 创建UDP socket
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_socket.bind((SERVER_IP, SERVER_PORT))  # 绑定IP和端口

    print(f"Server is listening on {SERVER_IP}:{SERVER_PORT}...")

    # 确保保存文件的目录存在
    if not os.path.exists(SAVE_DIR):
        os.makedirs(SAVE_DIR)

    # 接收文件名
    file_name, addr = server_socket.recvfrom(BUFFER_SIZE)  # 接收文件名
    file_name = file_name.decode()  # 解码为字符串

    # 创建接收文件的完整路径
    file_path = os.path.join(SAVE_DIR, f"received_{file_name}")

    print(f"Receiving file: {file_name} from {addr}")

    # 打开文件准备接收数据
    with open(file_path, 'wb') as f:
        while True:
            # 接收数据
            data, addr = server_socket.recvfrom(BUFFER_SIZE)
            if not data:  # 如果接收到的数据为空，说明文件传输结束
                break
            f.write(data)  # 写入文件

    print(f"File received and saved as {file_path}")

    # 关闭socket
    server_socket.close()

if __name__ == "__main__":
    receive_file()

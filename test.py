import cv2

# Inisialisasi webcam (biasanya 0 untuk default webcam)
cap = cv2.VideoCapture(0)

# Set resolusi ke nilai maksimum umum (misal 1920x1080), kamu bisa ganti sesuai kemampuan webcam
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1920)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 1080)

# Ambil resolusi aktual setelah diset
width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
print(f"Resolusi webcam: {int(width)}x{int(height)}")

while True:
    ret, frame = cap.read()
    if not ret:
        print("Gagal menangkap frame dari webcam.")
        break

    cv2.imshow("Webcam Full Resolution", frame)

    # Tekan 'q' untuk keluar
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()

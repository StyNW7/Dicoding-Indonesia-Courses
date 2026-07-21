export class CameraService {
  constructor() {
    this.stream = null;
    this.video = null;
    this.canvas = null;
    this.devices = [];
    this.config = {
      fps: 30,
    };
  }

  setVideoElement(videoElement) {
    this.video = videoElement;
  }

  setCanvasElement(canvasElement) {
    this.canvas = canvasElement;
  }

  // TODO [Basic] Tambahkan konfigurasi kamera untuk mendapatkan daftar perangkat input video
  async loadCameras() {
    try {
      const allDevices = await navigator.mediaDevices.enumerateDevices();
      this.devices = allDevices.filter((device) => device.kind === 'videoinput');
      return this.devices;
    } catch (error) {
      console.error('Gagal memuat daftar kamera:', error);
      this.devices = [];
      return this.devices;
    }
  }

  // TODO [Basic] Dapatkan constraints kamera berdasarkan konfigurasi dan kamera yang dipilih
  getConstraints(selectedCameraId) {
    const videoConstraints = {
      width: { ideal: 640 },
      height: { ideal: 480 },
      frameRate: { ideal: this.config.fps, max: this.config.fps },
    };

    if (selectedCameraId === 'front') {
      videoConstraints.facingMode = 'user';
    } else {
      videoConstraints.facingMode = 'environment';
    }

    return { video: videoConstraints, audio: false };
  }

  // TODO [Basic] Memulai kamera dengan perangkat yang dipilih dan menampilkan pada elemen video
  async startCamera(selectedCameraId = 'default') {
    this.stopCamera();

    const constraints = this.getConstraints(selectedCameraId);
    this.stream = await navigator.mediaDevices.getUserMedia(constraints);

    if (this.video) {
      this.video.srcObject = this.stream;
      await new Promise((resolve) => {
        this.video.onloadedmetadata = () => {
          this.video.play();
          resolve();
        };
      });
    }

    return this.stream;
  }

  // TODO [Basic] Menghentikan siaran kamera dan membersihkan sumber daya
  stopCamera() {
    if (this.stream) {
      this.stream.getTracks().forEach((track) => track.stop());
      this.stream = null;
    }

    if (this.video) {
      this.video.srcObject = null;
    }
  }

  // TODO [Skilled] Implementasikan metode untuk mengatur FPS kamera
  setFPS(fps) {
    this.config.fps = fps;
  }

  getFPS() {
    return this.config.fps;
  }

  // TODO [Basic] Periksa apakah kamera sedang aktif
  isActive() {
    return Boolean(this.stream && this.stream.active);
  }

  // TODO [Basic] Periksa apakah elemen video siap untuk digunakan
  isReady() {
    return Boolean(this.video && this.video.readyState >= 2);
  }
}

import { useRef, useState, useEffect, useCallback } from 'react';
import Header from './components/Header';
import CameraSection from './components/CameraSection';
import InfoPanel from './components/InfoPanel';
import { useAppState } from './hooks/useAppState';
import { CameraService } from './services/CameraService';
import { DetectionService } from './services/DetectionService';
import { RootFactsService } from './services/RootFactsService';
import { APP_CONFIG, isValidDetection } from './utils/config';
import { createDelay, getCameraErrorMessage, logError } from './utils/common';

function App() {
  const { state, actions } = useAppState();
  const detectionCleanupRef = useRef(null);
  const isRunningRef = useRef(false);
  const [currentTone, setCurrentTone] = useState('normal');

  // TODO [Basic] Inisialisasi layanan deteksi, kamera, dan generator fakta saat aplikasi dimuat
  useEffect(() => {
    const detector = new DetectionService();
    const camera = new CameraService();
    const generator = new RootFactsService();

    actions.setServices({ detector, camera, generator });

    const initModels = async () => {
      try {
        actions.setModelStatus('Menunggu Model AI... 0%');

        await Promise.all([
          detector.loadModel((fraction) => {
            actions.setModelStatus(`Menunggu Model AI... ${Math.round(fraction * 100)}%`);
          }),
          generator.loadModel(),
        ]);

        await camera.loadCameras();

        actions.setModelStatus('Model AI Siap');
      } catch (error) {
        logError('Gagal memuat model AI', error);
        actions.setModelStatus('Gagal Memuat Model');
        actions.setError('Gagal memuat model AI. Silakan muat ulang halaman.');
      }
    };

    initModels();

    // TODO [Basic] Bersihkan sumber daya saat komponen ditinggalkan
    return () => {
      isRunningRef.current = false;
      if (detectionCleanupRef.current) {
        clearTimeout(detectionCleanupRef.current);
      }
      camera.stopCamera();
    };
  }, [actions]);

  // TODO [Basic] Fungsi untuk memulai loop deteksi
  const startDetectionLoop = useCallback(() => {
    isRunningRef.current = true;

    const detectFrame = async () => {
      if (!isRunningRef.current) return;

      const { detector, camera, generator } = state.services;

      if (detector?.isLoaded() && camera?.isReady()) {
        try {
          const result = await detector.predict(camera.video);

          if (isValidDetection(result)) {
            isRunningRef.current = false;
            actions.setAppState('analyzing');

            await createDelay(APP_CONFIG.analyzingDelay);

            actions.setDetectionResult(result);
            actions.setFunFactData(null);
            actions.setAppState('result');

            try {
              const [factText] = await Promise.all([
                generator.generateFacts(result.className),
                createDelay(APP_CONFIG.factsGenerationDelay),
              ]);
              actions.setFunFactData(factText);
            } catch (error) {
              logError('Gagal menghasilkan fun fact', error);
              actions.setFunFactData('error');
            }

            return;
          }
        } catch (error) {
          logError('Deteksi gagal', error);
        }
      }

      const fps = camera?.getFPS ? camera.getFPS() : 30;
      const interval = Math.max(1000 / fps, APP_CONFIG.detectionRetryInterval);
      detectionCleanupRef.current = setTimeout(detectFrame, interval);
    };

    detectFrame();
  }, [state.services, actions]);

  // TODO [Basic] Fungsi untuk memulai dan menghentikan kamera
  const handleToggleCamera = useCallback(async () => {
    const { camera } = state.services;
    if (!camera) return;

    if (state.isRunning) {
      isRunningRef.current = false;
      if (detectionCleanupRef.current) {
        clearTimeout(detectionCleanupRef.current);
        detectionCleanupRef.current = null;
      }
      camera.stopCamera();
      actions.setRunning(false);
      actions.resetResults();
      return;
    }

    try {
      actions.resetResults();
      await camera.startCamera('default');
      actions.setRunning(true);
      startDetectionLoop();
    } catch (error) {
      logError('Gagal memulai kamera', error);
      actions.setError(getCameraErrorMessage(error));
    }
  }, [state.services, state.isRunning, actions, startDetectionLoop]);

  // TODO [Advance] Fungsi untuk mengubah nada fakta yang dihasilkan
  const handleToneChange = useCallback((tone) => {
    setCurrentTone(tone);
    if (state.services.generator) {
      state.services.generator.setTone(tone);
    }
  }, [state.services]);

  // TODO [Skilled] Fungsi untuk menyalin fakta ke clipboard
  const handleCopyFact = useCallback(async () => {
    if (!state.funFactData || state.funFactData === 'error') return;

    try {
      await navigator.clipboard.writeText(state.funFactData);
    } catch (error) {
      logError('Gagal menyalin ke clipboard', error);
      actions.setError('Gagal menyalin fakta ke clipboard.');
    }
  }, [state.funFactData, actions]);

  return (
    <div className="app-container">
      <Header modelStatus={state.modelStatus} />

      <main className="main-content">
        <CameraSection
          isRunning={state.isRunning}
          onToggleCamera={handleToggleCamera}
          onToneChange={handleToneChange}
          services={state.services}
          modelStatus={state.modelStatus}
          error={state.error}
          currentTone={currentTone}
        />

        <InfoPanel
          appState={state.appState}
          detectionResult={state.detectionResult}
          funFactData={state.funFactData}
          error={state.error}
          onCopyFact={handleCopyFact}
        />
      </main>

      <footer className="footer">
        <p>Powered by TensorFlow.js & Transformers.js</p>
      </footer>

      {state.error && (
        <div style={{
          position: 'fixed',
          bottom: '1rem',
          left: '50%',
          transform: 'translateX(-50%)',
          maxWidth: '380px',
          padding: '0.875rem 1rem',
          background: '#fef2f2',
          border: '1px solid #fecaca',
          borderRadius: 'var(--radius-md)',
          color: '#991b1b',
          fontSize: '0.8125rem',
          boxShadow: 'var(--shadow-lg)',
          display: 'flex',
          alignItems: 'center',
          gap: '0.5rem',
          zIndex: 1000
        }}>
          <strong>Error:</strong> {state.error}
          <button
            onClick={() => actions.setError(null)}
            style={{
              marginLeft: 'auto',
              background: 'transparent',
              border: 'none',
              fontSize: '1.25rem',
              cursor: 'pointer',
              color: '#991b1b',
              padding: 0,
              lineHeight: 1
            }}
          >
            ×
          </button>
        </div>
      )}
    </div>
  );
}

export default App;

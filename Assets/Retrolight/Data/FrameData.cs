using UnityEngine;
using UnityEngine.Rendering;

namespace Retrolight.Data {
    public readonly struct FrameData {
        public readonly Camera Camera;
        public readonly CullingResults Cull;
        public readonly ViewportParams ViewportParams;

        public FrameData(Camera camera, CullingResults cull, ViewportParams viewportParams) {
            Camera = camera;
            Cull = cull;
            ViewportParams = viewportParams;
        }
    }
}
using UnityEngine;
using UnityEngine.Rendering;

public class Cubes : MonoBehaviour
{
    [SerializeField, Range(0f, 360f)] private float Angle;
    [SerializeField, Range(0f, 40f)] private float Frequency;
    [SerializeField] private ComputeShader CubeShader;
    [SerializeField] private Mesh CubeMesh;
    [SerializeField] private Material CubeMaterial;

    private static int SimulationKernel;

    private static readonly int Direction = Shader.PropertyToID(name: "Direction");
    private static readonly int Positions = Shader.PropertyToID(name: "Positions");
    private static readonly int CurrentTime = Shader.PropertyToID(name: "Time");
    private static readonly int Freq = Shader.PropertyToID(name: "Frequency");




    private const int CubeAmount = 128 * 128;

    private Vector4[] CubePositions = new Vector4[CubeAmount];

    private Matrix4x4[] CubeMatrices = new Matrix4x4[CubeAmount];

    private ComputeBuffer CubeBuffer;

    private AsyncGPUReadbackRequest GPURequest;

    private void PopulateCubes(Vector4[] positions)
    {
        for (uint x = 0; x < 128; ++x)
        {
            for (uint y = 0; y < 128; ++y)
            {
                uint idx = x * 128 + +y;
                positions[idx] = new Vector4(x: x / 128f, y: 0, z: y / 128f);
            }
        }
    }

    private void DispatchCubes()
    {
        Vector2 dir =
            new Vector2(x: Mathf.Cos(f: Mathf.Deg2Rad * Angle), y: Mathf.Sin(f: Mathf.Deg2Rad * Angle));

        CubeShader.SetFloat(nameID: CurrentTime, Time.time);
        CubeShader.SetFloat(nameID: Freq, Frequency);
        CubeShader.SetVector(nameID: Direction, (Vector4)dir);

        CubeShader.Dispatch(SimulationKernel, threadGroupsX: 128 / 8, threadGroupsY: 128 / 8, threadGroupsZ: 128 / 8);
    }

    // Start is called before the first frame update
    void Start()
    {
        SimulationKernel = CubeShader.FindKernel(name: "Simulate");
        CubeBuffer = new ComputeBuffer(count: CubeAmount, stride:4 * sizeof(float));
        PopulateCubes(CubePositions);
        CubeBuffer.SetData(CubePositions);

        CubeShader.SetBuffer(SimulationKernel, nameID: Positions, CubeBuffer);

        GPURequest = AsyncGPUReadback.Request(CubeBuffer);

    }

    // Update is called once per frame
    void Update()
    {
        if (GPURequest.done)
        {
            CubePositions = GPURequest.GetData<Vector4>().ToArray();

            for (int i = 0; i < CubeAmount; ++i)
                CubeMatrices[i] = Matrix4x4.TRS(
                    pos: (Vector3)CubePositions[i] + transform.position,
                    Quaternion.identity, s: Vector3.one * (1 / 128f)
                    );

            GPURequest = AsyncGPUReadback.Request(CubeBuffer);
        }
        DispatchCubes();
        Graphics.DrawMeshInstanced(CubeMesh, submeshIndex: 0, CubeMaterial, CubeMatrices);
    }

    private void OnDisable()
    {
        
        CubeBuffer.Release();
    }

    private void OnDestroy()
    {
        CubeBuffer.Release();
    }

}


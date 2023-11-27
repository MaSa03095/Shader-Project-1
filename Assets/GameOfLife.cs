using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Experimental.Rendering;

public class GameOfLife : MonoBehaviour
{
    public enum GameInit
    {
        RPentomino,
        Acorn,
        GosperGun,
        FullTexture
    }

    [SerializeField] private GameInit Seed;

    [SerializeField] private Material PlaneMaterial;

    [SerializeField] private Color CellCol;

    [SerializeField] private ComputeShader Simulator;

    [SerializeField, Range(0f, 2f)] private float UpdateInterval;

    private float NextUpdate = 2f;

    //Tektuurien koko 512.512.
    private static readonly Vector2Int TexSize = new Vector2Int(512, 512);

    private RenderTexture State1;
    private RenderTexture State2;

    private bool IsState1;

    private static int RPentominoKernel;
    private static int AcornKernel;
    private static int GosperGunKernel;
    private static int FullTextureKernel;

    // Start is called before the first frame update
    void Start()
    {
        State1 = new RenderTexture(TexSize.x, TexSize.y, 0, DefaultFormat.LDR)
        {
            filterMode = FilterMode.Point,
            enableRandomWrite = true
        };

        State1.Create();

        State2 = new RenderTexture(TexSize.x, TexSize.y, 0, DefaultFormat.LDR)
        {
            filterMode = FilterMode.Point,
            enableRandomWrite = true
        };

        State2.Create();
        Update1Kernel = Simulator.FindKernel("Update1");
        Update2Kernel = Simulator.FindKernel("Update2");
        RPenTominoKernel = Simulator.FindKernel("InitRPentomino");
        AcornKernel = Simulator.FindKernel("InitAcorn");
        GunKernel = Simulator.FindKernel("InitGun");
        FullKernel = Simulator.FindKernel("InitFullTexture");

    
    

        Simulator.SetTexture(Update1Kernel, State1Tex, State1);
        Simulator.SetTexture(Update1Kernel, State2Tex, State2);

        Simulator.SetTexture(Update2Kernel, State1Tex, State1);
        Simulator.SetTexture(Update2Kernel, State2Tex, State2);

        Simulator.SetTexture(RPentominoKernel, State1Tex, State1);
        Simulator.SetTexture(AcornKernel, State1Tex, State1);
        Simulator.SetTexture(GunKernel, State1Tex, State1);
        Simulator.SetTexture(FullKernel, State1Tex, State1);

    }

    // Update is called once per frame
    void Update()
    {
        if (Time.time < NextUpdate) return;

        IsState1 = !IsState1;

        PlaneMaterial.SetTexture(BaseMap, IsState1 ? State1 : State2);

        NextUpdate = Time.time + UpdateInterval;

    }
    private void OnDisable()
    {
        State1.Release();
        State2.Release();
    }

    switch (Seed)
        {
        case GameInit.
        }
}

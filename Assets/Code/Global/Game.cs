using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace IBVSG
{

	public class Game : MonoBehaviour 
	{
		public static Object BeamPrefab;
		public static Object StonePrefab;
		public static Object EnemyPrefab;
		public static Object Explosion;
		public static Object Hit;

		public static GameState GameState = GameState.Start;

		public GameObject Player;
		public static Player PlayerScript;
		public List<GameObject> Waypoints;
		public static List<PowerUp> PowerUps;
		public static List<Enemy> Enemies;
		public static WaypointManager WaypointManager;

		public static Game Inst;

		private bool once;

		// Use this for initialization
		void Start () 
		{
			Inst = this;
			//Waypoints = new List<GameObject>();
			//WaypointManager = new WaypointManager(Waypoints);
			//Enemies = new List<Enemy>();
			//PowerUps = new List<PowerUp>();
			//Weapon beam = new Beam();
			//PlayerScript = new Player(Type.Player, 100.0f, beam, Player);

			BeamPrefab =  Resources.Load("Prefabs/BeamPrefab");
			StonePrefab = Resources.Load("Prefabs/StonePrefab");
			EnemyPrefab = Resources.Load("Prefabs/EnemyPrefab");
			Explosion   = Resources.Load("VFX/Explosion");
			Hit			= Resources.Load("VFX/Hit");
		}
		
		// Update is called once per frame
		void Update () 
		{
			if(Inst == null)
				Inst = this;

			if(Game.GameState == GameState.Play)
			{
				PlayerScript.Update();
				for(int i = 0; i < Enemies.Count; i++)
				{
					Enemies[i].Update();
				}
				for(int i = 0; i < PowerUps.Count; i++)
				{
					PowerUps[i].Update();
				}

				CountPoints();
				MakeItHarder();
			}


		}

		public void MakeItHarder()
		{
			if(TweakingVariables.PlayerStats.High % 20 == 19 && !once)
			{
				TweakingVariables.StatsUp();
				once = true;
			}

			if(TweakingVariables.PlayerStats.High % 20 == 0)
			{
				once = false;
			}
		}

		void GetEnemy()
		{
			GameObject enemies = GameObject.Find("Enemies");
			Transform[] allChildren = enemies.GetComponentsInChildren<Transform>();
			
			foreach (Transform child in allChildren)
			{
				if(child.name.Equals("EnemyPrefab"))
				{
					Weapon stone = new Stone();
					Enemies.Add(new Enemy(Type.Enemy, 100.0f, stone, child.gameObject));
				}
			}
		}

		public void CountPoints()
		{
			TweakingVariables.PlayerStats.High = (int)((PlayerScript.Position.y - TweakingVariables.PlayerStats.StartYPos));
			TweakingVariables.PlayerStats.Points = (int)(TweakingVariables.PlayerStats.High + TweakingVariables.PlayerStats.PointsFromKills);
		}

		public void StartGame()
		{
			Enemies = new List<Enemy>();
			PowerUps = new List<PowerUp>();
			Weapon beam = new Beam();
			PlayerScript = new Player(Type.Player, 100.0f, beam, Player);
			TweakingVariables.PlayerStats.StartYPos = PlayerScript.Position.y;
			GetEnemy();
		}

		public void EndGame()
		{
			Game.GameState = GameState.End;
			InputController.Timer = Time.time + 2.0f;
			TweakingVariables.RestartStatic();
		}
	}

	public enum Type
	{
		Player,
		Enemy
	}

	public enum GameState
	{
		Start,
		Play,
		End,
	}
}
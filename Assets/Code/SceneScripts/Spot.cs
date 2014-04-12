using UnityEngine;
using System.Collections;
using IBVSG;

public class Spot : MonoBehaviour 
{
	public Enemy Holder;
	public float SpawnTime = 5.0f;
	public float Timer;
	// Use this for initialization
	void Start () 
	{
	
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(Game.GameState == GameState.Play && Timer < Time.time)
			if(Vector3.Distance(Game.PlayerScript.Position, this.transform.position) < 5.0f)
			{
				if(Holder == null)
				{
					GameObject EnemyPref = GameObject.Instantiate(Game.EnemyPrefab) as GameObject;
					EnemyPref.transform.position = transform.position;

					Weapon stone = new Stone();
					Holder = new Enemy(Type.Enemy, 100.0f, stone, EnemyPref);
					Holder.Spot = this;
					Game.Enemies.Add(Holder);
				}
			}
	}
}

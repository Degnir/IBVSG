using UnityEngine;
using System.Collections;
using IBVSG;

public class Bounds : MonoBehaviour {

	public bool Up;
	public GameObject NextCollider;

	// Use this for initialization
	void Start () 
	{

	}
	
	// Update is called once per frame
	void Update () 
	{ 
		if(Game.GameState == GameState.Play && collider.bounds.Contains(Game.PlayerScript.Position))
		{
			if(Up)
			{
				TweakingVariables.PlayerStats.StartYPos -= (collider.bounds.min.y);

				Game.PlayerScript.Position = new Vector3(Game.PlayerScript.Position.x, 
				                                               NextCollider.collider.bounds.max.y + 1.0f,
				                                               Game.PlayerScript.Position.z); 
			}	
			else
			{
				TweakingVariables.PlayerStats.StartYPos += (NextCollider.collider.bounds.min.y);

				Game.PlayerScript.Position = new Vector3(Game.PlayerScript.Position.x, 
				                                               NextCollider.collider.bounds.min.y - 1.0f,
				                                               Game.PlayerScript.Position.z); 
			}

			for(int i = 0; i < Game.Enemies.Count; i++)
			{
				Game.Enemies[i].Health = 100.0f;
			}
		}
	}


}

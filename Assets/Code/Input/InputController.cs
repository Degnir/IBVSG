using UnityEngine;
using System.Collections;
using IBVSG;

public class InputController : MonoBehaviour {

	public static float Timer;
	// Use this for initialization
	void Start () 
	{
	
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(Timer < Time.time)
			if(Input.GetKey(KeyCode.Space))
			{
				switch (Game.GameState)
				{
					case GameState.Play:
						Game.PlayerScript.GoUp();
						Game.PlayerScript.MoveDirection(true);
						break;
					case GameState.End:
						Game.GameState = GameState.Start;
						Application.LoadLevel(Application.loadedLevelName);
						break;
					case GameState.Start:
						Game.Inst.StartGame();
						Game.GameState = GameState.Play;
						break;
				}

				/*if(Game.GameState == GameState.Play)
				{
				 	Game.PlayerScript.GoUp();
				 	Game.PlayerScript.MoveDirection(true);
				}
				else
				{
					Game.Inst.StartGame();
					Game.GameState = GameState.Play;
				}*/
			}
			else if (Game.GameState == GameState.Play)
			{
				Game.PlayerScript.MoveDirection(false);
			}

	}
}

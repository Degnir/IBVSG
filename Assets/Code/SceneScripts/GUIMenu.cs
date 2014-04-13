using UnityEngine;
using System.Collections;
using IBVSG;

public class GUIMenu : MonoBehaviour 
{
	public Texture2D title;
	public Texture2D icon;
	public GUISkin myskin = null;

	void OnGUI () 
	{
		GUI.skin = myskin;
		if(Game.GameState == GameState.Start)
		{
			GUI.Box(new Rect(Screen.width/3,Screen.height/4,750,250), title);

			GUI.Label(new Rect(Screen.width/3 + 240,Screen.height/4 + 140,300,200), "PRESS SPACE TO START");
			GUI.Label(new Rect(Screen.width/3 + 255,Screen.height/4 + 160,300,200), "GO KICK SOME CUBES");
		}
		else if(Game.GameState == GameState.End)
		{
			GUI.Box(new Rect(Screen.width/3,Screen.height/4,750,250), "");
			
			GUI.Label(new Rect(Screen.width/3 + 280,Screen.height/4 + 60,300,200), "NOT GOOD ENOUGH");
			GUI.Label(new Rect(Screen.width/3 + 240,Screen.height/4 + 80,300,200), "GO KICK SOME MORE CUBES");
			GUI.Label(new Rect(Screen.width/3 + 242,Screen.height/4 + 120,300,200), "PRESS SPACE TO RESTART");
		}

	}
}


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
			GUI.Box(new Rect(60,60,750,250), title);
			
			GUI.Label(new Rect(330,200,300,200), "PRESS SPACE TO START");
			GUI.Label(new Rect(340,220,300,200), "GO KICK SOME CUBES");
		}
		else if(Game.GameState == GameState.End)
		{
			GUI.Box(new Rect(60,60,750,250),"");
			GUI.Label(new Rect(345,100,300,200), "NOT GOOD ENOUGH");
			GUI.Label(new Rect(310,120,300,200), "GO KICK SOME MORE CUBES");
			GUI.Label(new Rect(312,180,300,200), "PRESS SPACE TO RESTART");
		}

	}
}


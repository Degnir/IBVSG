using System;
using UnityEngine;
using IBVSG;

public class Stats : MonoBehaviour
{
	public GUISkin myskin = null;

	public Texture2D bgImage;
	public Texture2D fgImage;

	void OnGUI()
	{
		GUI.skin = myskin;
		if(Game.GameState == GameState.Play)
		{
			GUI.Label(new Rect(20,30,300,200), "SCORE: ");
			GUI.Label(new Rect(90,30,300,200), TweakingVariables.PlayerStats.Points.ToString());

			GUI.BeginGroup (new  Rect (0,0,256,32));

				GUI.BeginGroup (new Rect (0,0, Game.PlayerScript.Health/100 * 256, 32));

				GUI.Box (new Rect (0,0,256,32), fgImage);

				GUI.EndGroup ();

			GUI.EndGroup ();
		}
	}
}


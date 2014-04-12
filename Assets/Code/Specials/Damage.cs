using UnityEngine;
using System;

namespace IBVSG
{
	public class Damage : PowerUp
	{

		public Damage (PowerUpType type, float duration) : base (type, duration)
		{
		}
		
		public override void EffectOn ()
		{
			base.EffectOn ();
			Game.PlayerScript.Weapon = new SuperBeam();
			Game.PlayerScript.Weapon.Owner = Game.PlayerScript;
		}
		
		public override void EffectOff ()
		{
			Game.PlayerScript.Weapon = new Beam();
			Game.PlayerScript.Weapon.Owner = Game.PlayerScript;
		}
	}
}


using UnityEngine;
using System;

namespace IBVSG
{
	public class Health : PowerUp
	{
		public float HealthUp;

		public Health (PowerUpType type, float power, float duration) : base (type, duration)
		{
			HealthUp = power;
		}

		public override void EffectOn ()
		{
			base.EffectOn ();
			Game.PlayerScript.Health += HealthUp;
			if(Game.PlayerScript.Health > 100)
			{
				Game.PlayerScript.Health = 100;
			}
		}
	}
}


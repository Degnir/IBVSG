using UnityEngine;
using System;

namespace IBVSG
{
	public class Speed : PowerUp
	{
		public float SpeedUp;
		
		public Speed (PowerUpType type, float power, float duration) : base (type, duration)
		{
			SpeedUp = power;
		}
		
		public override void EffectOn ()
		{
			base.EffectOn ();
			TweakingVariables.PlayerProps.Speed *= SpeedUp;
		}

		public override void EffectOff ()
		{
			TweakingVariables.PlayerProps.Speed /= SpeedUp;
		}

	}
}

using UnityEngine;
using System;

namespace IBVSG
{
	public class PowerUp
	{
		public GameObject Model;
		public PowerUpType Type;
		public float Duration;

		private float _Timer;

		public PowerUp (PowerUpType type, float duration)
		{
			Type = type;
			Duration = duration;
		}

		public virtual void EffectOn()
		{
			_Timer = Time.time + Duration;
		}

		public virtual void EffectOff(){}

		public virtual void Update()
		{
			if(_Timer < Time.time)
			{
				EffectOff();
				Game.PowerUps.Remove(this);
			}
		}

	}

	public enum PowerUpType
	{
		Speed,
		Health,
		Damage
	}
}


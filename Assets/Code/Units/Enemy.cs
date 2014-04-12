using System;
using UnityEngine;

namespace IBVSG
{
	public class Enemy : Unit
	{
		public GameObject WeaponMuzzle;
		public Spot Spot;
		public PowerUp PowerUp;
		
		public override Vector3 MuzzlePosition()
		{
			return WeaponMuzzle.transform.position;
		}

		public Enemy (Type type, float health, Weapon weapon, GameObject model) : base(type, health, weapon, model)
		{
			weapon.Owner = this;
			Transform[] allChildren = model.GetComponentsInChildren<Transform>();
			
			foreach (Transform child in allChildren)
			{
				if(child.name.Equals("Muzzle"))
				{
					WeaponMuzzle = child.gameObject;
				}
			}

			System.Random rnd = new System.Random();
			int random = rnd.Next(1, 101);

			if(random <= 50 )
			{
				if(random <= 15)
				{
					PowerUp = new IBVSG.Speed(PowerUpType.Speed, 2.0f, 3.0f);
					Model.renderer.material.color = Color.blue;
				}
				else if (random < 30)
				{
					PowerUp = new IBVSG.Damage(PowerUpType.Speed, 3.0f);
					Model.renderer.material.color = Color.red;
				}
				else
				{
					PowerUp = new IBVSG.Health(PowerUpType.Health, 20.0f, 1.0f);
					Model.renderer.material.color = Color.green;
				}

					
			}
		}

		public override void Update ()
		{
			base.Update();

		}

		public override void Die ()
		{
			base.Die ();

			if(Spot != null)
			{
				Spot.Timer = TweakingVariables.SpotProps.SpawTime + Time.time;
				Spot.Holder = null;
			}
			if(PowerUp != null)
			{
				PowerUp.EffectOn();
				Game.PowerUps.Add(PowerUp);
			}
			TweakingVariables.PlayerStats.PointsFromKills += 10;
			
			GameObject explosion = GameObject.Instantiate(Game.Explosion) as GameObject;
			explosion.transform.position = Position;
			explosion.particleSystem.Play();
			
			Game.Enemies.Remove(this);
			GameObject.Destroy(Model);
			GameObject.Destroy(explosion, explosion.particleSystem.duration);
		}
	}
}


using System;
using UnityEngine;

namespace IBVSG
{
	public class Beam : Weapon
	{
		public Beam ()
		{
			Damage = TweakingVariables.BeamProps.Damage;
			Cooldown =  TweakingVariables.BeamProps.Cooldown;
		}

		public override void Shoot ()
		{
			base.Shoot();

			if(Owner.ClosestEnemy != null)
			{
				Vector3 relativePos = Owner.ClosestEnemy.Position - Owner.Position;
				Quaternion newRotation = Quaternion.LookRotation(relativePos);
				
				GameObject bullet = GameObject.Instantiate(Game.BeamPrefab, Owner.MuzzlePosition(), newRotation) as GameObject;
				Bullet script = bullet.AddComponent("Bullet") as Bullet;
				script.Target = Owner.ClosestEnemy;
				script.Owner = Owner;
				script.Speed = TweakingVariables.BeamProps.Speed;
			}

		}

	}
}


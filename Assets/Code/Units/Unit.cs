using UnityEngine;
using System.Collections;

namespace IBVSG
{
	public class Unit 
	{
		public GameObject Model;

		public float Health;
		public Weapon Weapon;
		public Type Type;
		public Unit ClosestEnemy;
		public bool IsVisible = true;

		public virtual Vector3 MuzzlePosition () { return Vector3.zero;}

		public virtual void ShootEffect () {}

		public Unit(Type type, float health, Weapon weapon, GameObject model) 
		{
			Type = type;
			Health = health;
			Weapon = weapon;
			Model = model;
		}

		public Vector3 Position
		{
			get 
			{ 
				return Model.transform.position; 
			}
			set
			{
				Model.transform.position = value;
			}
		}

		public Vector3 GetPosition()
		{
			return Model.transform.position;
		}

		public virtual void Update() 
		{
			if(Type == Type.Player)
			{
				ClosestEnemy = GetClosestEnemy();
			}
			else
			{
				ClosestEnemy = Game.PlayerScript;

				if (Model.renderer.isVisible) 
				{
					IsVisible = true;
				}
				else
				{
					IsVisible = false;
				}
			}

			if(ClosestEnemy != null && Weapon != null)
				Weapon.Update();

			if(Health < 0)
			{
				Die ();
			}
		}

		public Unit GetClosestEnemy()
		{
			float distance = 0;
			float minDistance = Mathf.Infinity;
			Unit target = null;

			for(int i = 0; i < Game.Enemies.Count; i++)
			{
				if(Game.Enemies[i].IsVisible)
				{
					distance = Vector3.Distance(this.Position, Game.Enemies[i].Position);
					if(distance < minDistance)
					{
						minDistance = distance;
						target = Game.Enemies[i];
					}
				}
			}

			return target;
		}

		public void Hit(Bullet bullet)
		{
			Health -= bullet.Owner.Weapon.Damage;

			GameObject hit = GameObject.Instantiate(Game.Hit) as GameObject;
			hit.transform.position = bullet.transform.position;
			hit.particleSystem.Play();
			GameObject.Destroy(hit, hit.particleSystem.duration);
		}

		public virtual void Die() 
		{

		}

	}
}

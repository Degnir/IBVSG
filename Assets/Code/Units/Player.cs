
using System;
using UnityEngine;
using System.Collections.Generic;

namespace IBVSG
{
	public class Player : Unit
	{
		public List<GameObject> IronMens;
		public GameObject CyclopBeam;

		public override Vector3 MuzzlePosition()
		{
			return CyclopBeam.transform.position;
		}

		public override void ShootEffect ()
		{
			CyclopBeam.particleSystem.Play();
		}

		public Player (Type type, float health, Weapon weapon, GameObject model) : base(type, health, weapon, model)
		{
			IronMens = new List<GameObject>();
			weapon.Owner = this;

			Transform[] allChildren = model.GetComponentsInChildren<Transform>();

			foreach (Transform child in allChildren)
			{
				if(child.name.Equals("IronMen"))
				{
					IronMens.Add(child.gameObject);
				}
				else if(child.name.Equals("CyclopBeam"))
				{
					CyclopBeam = child.gameObject;
				}
			}
			MoveDirection(false);
			CyclopBeam.particleSystem.Stop();
			//CyclopBeam.particleSystem.enableEmission = false;
		}

		public override void Update ()
		{
			base.Update();
			Model.transform.position += Vector3.up * - 0.013f;
		}

		public void GoUp()
		{
			Model.transform.position += Vector3.up * TweakingVariables.PlayerProps.Speed * 2;
		}

		public void MoveDirection(bool Up)
		{
			if(Up)
			{
				for(int i = 0; i < IronMens.Count; i++)
				{
					IronMens[i].particleSystem.enableEmission = true;
				}
			}
			else
			{
				for(int i = 0; i < IronMens.Count; i++)
				{
					IronMens[i].particleSystem.enableEmission = false;
				}
			}
		}

		public override void Die ()
		{
			base.Die ();
			Game.Inst.EndGame();
			GameObject explosion = GameObject.Instantiate(Game.Explosion) as GameObject;
			explosion.transform.position = this.Position;
			explosion.particleSystem.Play();
			MoveDirection(false);

			Transform[] allChildren = Model.GetComponentsInChildren<Transform>();
			
			foreach (Transform child in allChildren)
			{
				if(child.name.Equals("Object001"))
				{
					child.gameObject.SetActive(false);
					break;
				}
			}

			GameObject.Destroy(explosion, explosion.particleSystem.duration);
		}
	}
}


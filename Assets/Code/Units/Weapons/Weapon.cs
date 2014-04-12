using UnityEngine;
using System.Collections;
using IBVSG;

public abstract class Weapon 
{
	public GameObject Model; //if any?
	public float Damage;
	public Unit Owner;
	public float Cooldown;

	private float _Timer;
	private RaycastHit _Ray;

	// Use this for initialization
	public Weapon () 
	{

	}

	public void Update()
	{
		if(CheckVisibility())
		{
			if(CanShoot())
				Shoot();
		}
	}

	public bool CanShoot()
	{
		if(_Timer < Time.time && Vector3.Distance(Owner.ClosestEnemy.Position, Owner.Position) < 3.0f)
			return true;
		else
			return false;
	}

	public bool CheckVisibility()
	{
		if(Physics.Raycast(Owner.Position, (Owner.ClosestEnemy.Position - Owner.Position).normalized, out _Ray))
		{
			if(Owner.Type == Type.Player)
			{
				if(_Ray.collider.tag == "Enemy")
					return true;
			}
			else
			{
				if(_Ray.collider.tag == "Player")
					return true;
			}
		}
		return false;
	}

	public virtual void Shoot()
	{
		_Timer = Time.time + Cooldown;
		Owner.ShootEffect();
	}

}

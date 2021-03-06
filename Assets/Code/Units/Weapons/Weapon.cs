﻿using UnityEngine;
using System.Collections;
using IBVSG;

public abstract class Weapon 
{
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
		int layer;
		
		if(Owner.Type == Type.Enemy)
		{
			layer = 1 << 8;
		}
		else
		{
			layer = 1 << 9;
		}

	    if(Physics.Raycast(Owner.MuzzlePosition(), (Owner.ClosestEnemy.MuzzlePosition() - Owner.MuzzlePosition()).normalized, out _Ray, layer))
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

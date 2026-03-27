package com.sushil.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sushil.auth.entity.User;

public interface UserRepository extends JpaRepository<User, Long>{

}

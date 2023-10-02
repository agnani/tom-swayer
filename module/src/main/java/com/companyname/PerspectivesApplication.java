package com.companyname;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.UserDetailsServiceAutoConfiguration;
import org.springframework.context.annotation.Import;

import com.tomsawyer.web.server.configuration.TSPerspectivesWebContextConfiguration;


/**
 * Spring Boot Application wrapper for Tom Sawyer Perspectives.
 */
@Import({TSPerspectivesWebContextConfiguration.class})
@SpringBootApplication(exclude = {UserDetailsServiceAutoConfiguration.class })
public class PerspectivesApplication
{
	/**
	 * Entry point into the Perspectives Spring Boot Application.
	 *
	 * @param args The command line arguments.
	 */
	public static void main(String[] args)
	{
		SpringApplication.run(PerspectivesApplication.class, args);
	}
}

package hibernatepanache;

import javax.enterprise.context.ApplicationScoped;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.Response;

import java.util.List;

@Path("entity/person")
@ApplicationScoped
@Produces("application/json")
@Consumes("application/json")
public class PersonResource {

    @GET
    public List<Person> get() {
        return Person.listAll();
    }

    @POST
    @Transactional
    public Response create() {

        Person person = new Person();
        person.setName("NewPerson");

        person.persist();
        return Response.ok(person).status(201).build();
    }

}
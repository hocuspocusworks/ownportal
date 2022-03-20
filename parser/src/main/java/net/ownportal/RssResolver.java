package net.ownportal;

import java.io.ByteArrayInputStream;
import java.util.Optional;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.UnmarshalException;
import net.ownportal.rssjax.Rss;

public class RssResolver {
    public boolean isValid(final byte[] rss) {
        try {
            var context = JAXBContext.newInstance(Rss.class);
            var unmarshaller = context.createUnmarshaller();
            unmarshaller.unmarshal(new ByteArrayInputStream(rss));
        } catch (UnmarshalException e) {
            // incorrect format
            // e.printStackTrace();
            return false;
        } catch (JAXBException e) {
            // general problem
            // e.printStackTrace();
            return false;
        }
        return true;
    }

    public Optional<Rss> rssFromBytes(final byte[] rss) {
        if (!isValid(rss)) {
            return Optional.empty();
        }
        try {
            var context = JAXBContext.newInstance(Rss.class);
            var unmarshaller = context.createUnmarshaller();
            return Optional.of((Rss) unmarshaller.unmarshal(new ByteArrayInputStream(rss)));
        } catch (JAXBException e) {
            return Optional.empty();
        }
    }
}

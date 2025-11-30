FROM ruby:2.7
#  https://blog.sshn.me/posts/invalid-byte-sequence-in-usascii/ 
ENV RUBYOPT -EUTF-8

RUN mkdir /work /data /log

RUN apt-get update && \
    apt-get install -y libraptor2-0 && \
    rm -rf /var/lib/apt/lists/*

ADD ./ /

WORKDIR /

RUN git clone https://github.com/med2rdf/clinvar.git clinvar-rdf

RUN cd /clinvar-rdf && \
    sed -i "/spec.add_development_dependency 'bundler', '~> 1.16'/ s/^/  # /" clinvar.gemspec && \
    rm -f Gemfile.lock && \
    bundle install && \
    rake install

WORKDIR /data

ENTRYPOINT [ "/convert_clinvar" ]


Reviewers' comments:


Reviewer #2: The authors study an opinion dynamics model with multiple issues
that is an extension of a previously studied model by the same authors
(reference [28]), based on a Bayesian update rule. Given that interactions
between two agents make their opinions closer to each other, they find that the
mean opinion over all issues converges to a central value, as expected. However,
opinions on a particular issue might become quite spread over the range of
possible values, with a dispersion that mainly depends on the type of
interaction (using the mean opinion or a specific opinion) and on parameters
like sigma that measures the interaction range, the number of issues n, and the
noise amplitude rho.

The model and its outcomes are analyzed in detail using different techniques.
The conclusions drawn on the system's behavior make sense and I believe are
correct. However, I think that the model is not properly defined and the update
rules are poorly justified, so it is hard to have an intuition on why opinions
are updated following equation (1). I admit that I do not fully understand the
model, so results are hard to follow even though I trust they are correct (see
bellow for specific points of the model). This makes me to hesitate to accept
the article. They authors should reformulate the model in clear terms and
explain its rules in a more intuitive way.

1) The model defined in section 2 extends the Bayesian updating rules introduced
in [28] for continuum opinion dynamics on a single issue to many issues, using
concepts of statistical inference, etc. These concepts are not explained in the
definition of the model, which I believe are already hard to understand for the
one issue model [28].

- Are opinions in the range [0,1]? They should state that.

- They should explain the Bayesian rule in words, or more intuitively.

- They should explain the concept of uncertainty and estimation. What does
  uncertainty mean? Why do agents have to estimate opinions? Don't they know
  their own opinions? Or is there an observation error when looking at the
  opinion of the interacting partner? Are there empirical evidence of the
  Bayesian approach or statistical inference in opinion dynamics? What are the
  sociological fundamentals of mechanisms of the model?

2) The opinion update is similar to that of continuum opinion models where two
agents adopt their average opinion (although here only one agents changes
opinion), with the addition of a weight p*. What is the physical meaning of p*?
Can they explain this interaction rule more intuitively?

3) The physical meaning of sigma is quite confusing. In the conclusion they
mention that sigma defines the trust of one agent on other agent. Why? Why do
stubborn agents have sigma=1e-20? They also mention that sigma plays the role of
the threshold in Bounded confidence models (BCM). However, in page 4 it is
mentioned that Delta_ij also plays the role of the threshold in BCM. However,
sigma and Delta_ij seem to be independent variables. They should clarify that.

4) It is not clear to me how simulations were done. "..one sampling of 70,000
times.." means 70,000 independent realizations of the dynamics? Related to this
point: was the distribution of Fig. 1 done over many different runs of the
model? If that is the case, then it is hard to see whether there is consensus or
not in individual realizations. The should add a plot (or perhaps an inset)
showing the mean opinion of each agent in an single realization. What are the
parameter values sigma, n and p of Fig. 1?

5) Why do they take rho_2=sqrt(n)*rho_1 in page 13 instead of, for instance,
rho_2=n*rho_1?

6) It is mentioned in the conclusions "...it makes sense to change how trust is
calculated to a situation that is more compatible with experiments". They should
cite related experiments.


Reviewer #3: Although this paper contains interesting thoughts and
considerations, I am not sure whether it meets the standards of the journal in
terms of contribution to the field. Let me elaborate:

-       The idea to make an opinion updating mechanism dependent on the distance
between the two individuals on multiple issues (i.e., not only the issue on
which opinion is updated) is natural and intuitively appealing. However, the way
in which this process is operationalized, is rather simplistic: either the
distances between opinions on every matter are taken into account (by taking
their average), or only on one. In reality, of course, the distance for some
opinions would be expected to carry more weight than those for other opinions.
Say, I am updating my opinion on capital punishment (death penalty) when talking
to someone. Then it seems likely that the difference between her opinion and
mine on a related topic (e.g. euthanesia or abortion) is more important to my
updating process, than the difference between her opinion and mine on a less
related issue such as environmental protection. In other words, I would have
expected the authors to incorporate some notion of 'relevance' or 'similarity'
to represent that distances - between individuals - in their opinions regarding
'similar' issues, into their model. As it is now, the model presents a rather
crude extension of previous work.

-       Second, I found the paper lacking in empirical grounding. In terms of
the micro-underpinnings of the model, I was expecting to see much more
references to empirical work justifying the notion that opinion-distance is a
relevant factor in opinion updating processes; and the notion that
opinion-distance on other (more or less related) opinions plays a role, too (see
previous point). Without such empirical evidence, statements such as "how much
each agent trusts another agent should be a function of the distance between
their opinions on the subject they are debating" sound a bit unfounded. And this
statement of course, refers to the core of the paper's aimed for contribution.
Likewise, I was expecting to see more reference to macro-level empirical work,
which could either help justify the assumptions embedded in the model proposed
by the authors, or be used as a validation-benchmark for the aggregate levels
outcomes generated by the model. Without such empirical reference, claims made
e.g. in the first phrases in the conclusions section feel unwarranted or at
least as lacking empirical grounding. And then ultimately, one has to resort to
much weaker claims such as the ones made in the abstract (where the use of the
word 'might' gives away that in fact, we really do not know for sure if this is
how things play out in real life).

Together, these issues make me doubt whether the paper deserves to be published
in Physica A; I could imagine it becoming a much stronger contribution, if they
were addressed in a substantially revised version.

# Modifications to the Paper: Ideologically Motivated Biases in a Multiple Issues Opinion Model

We would like to thank the referees for their comments. The modifications we introduced in the paper in order to make it clearer as described bellow.


- Reviewer 2 wrote: "Are opinions in the range [0,1]? They should state that."
  - Its stated at the beginning, second paragraph, of section 2;

- Reviewer 2 said:
  - “They should explain the Bayesian rule in words, or more intuitively.”

  - “They should explain the concept of uncertainty and estimation. What does
    uncertainty mean? Why do agents have to estimate opinions? Don’t they know
    their own opinions? Or is there an observation error when looking at the
    opinion of the interacting partner? Are there empirical evidence of the
    Bayesian approach or statistical inference in opinion dynamics? What are the
    sociological fundamentals of mechanisms of the model?”

 - We have added two paragraphs at the beginning of section 2 to state the
 framework we’re using. Details about the meaning and using of the Bayesian
 framework were also introduced. We also indicated previous works that go deeper
 into these details


- Reviewer 2 wrote: "What is the physical meaning of p*? Can they explain this
interaction rule more intuitively?"
  - ???????

- Reviewer 2 : "3) The physical meaning of sigma is quite confusing. In the
  conclusion they mention that sigma defines the trust of one agent on other
  agent. Why? Why do stubborn agents have sigma=1e-20?"
  - That is an implementation detail. We have modified the fourth paragraph of
    section 2 so that it should be clear that what we’re modeling is a sigma
    close to 0, that is agents that basically do not change their opinions
    (inflexibles).


- Reviewer 2: "They also mention that sigma plays the role of the threshold in
  Bounded confidence models (BCM). However, in page 4 it is mentioned that
  Delta$_{ij}$ also plays the role of the threshold in BCM. However, sigma and
  Delta$_{ij}$ seem to be independent variables. They should clarify that."
  - We have modified the first paragraph of the last section and the description
    of Deltaij in section 2 to fix that. There was indeed a mistake in that,
    while the distance Deltaij is related to trust, it is indeed sigma that
    plays the role of the threshold parameter, while the trust between agents is
    a function of the ratio between Deltaij and sigma. Modifications were
    introduced to correct for the actual meaning of each parameter.


- Reviewer 2: " It is not clear to me how simulations were done. "..one sampling
  of 70,000 times.." means 70,000 independent realizations of the dynamics?
  Related to this point: was the distribution of Fig. 1 done over many different
  runs of the model? If that is the case, then it is hard to see whether there
  is consensus or not in individual realizations. The should add a plot (or
  perhaps an inset) showing the mean opinion of each agent in an single
  realization. What are the parameter values sigma, n and p of Fig. 1?"
  - We answered that by modifying the second paragraph of section 3. “Times” is
    equal to quasi-random “draws” following saltelli’s sampling (one of the
    paper’s bibliographic references). The fact that each of those draws
    correspond to a complete run of the model is now mentioned clearly. We have
    modified the paragraphs that explain Fig. 1 so that its clear we’re
    investing the behavior of the model over many parameterizations. We’ve
    identified and pointed out the difference between initial and final state of
    the model both in the plot and in paragraphs explaining it. Plots of
    individual runs are already depicted throughout the paper, with the improved
    text, we feel there is not need add another one here.

- Reviewer 2: "5) Why do they take rho_2=sqrt(n)*rho_1 in page 13 instead of,
for instance, rho_2=n*rho_1?"
  - ?????


-  Reviewer 2: “6) It is mentioned in the conclusions”. . . it makes sense to
   change how trust is calculated to a situation that is more compatible with
   experiments“. They should cite related experiments.”
  -  We have added references on trust at the end of this sentence in the
     conclusion section. The new paragraph in the Introduction with results from
     cognitive science also provides the missing justification for the model
     assumptions.


- Reviewer 3:
  - " I would have expected the authors to incorporate some notion of
    'relevance' or 'similarity' to represent that distances - between
    individuals - in their opinions regarding 'similar' issues, into their
    model. As it is now, the model presents a rather crude extension of previous
    work."
  - " I found the paper lacking in empirical grounding. In terms of the
    micro-underpinnings of the model, I was expecting to see much more
    references to empirical work justifying the notion that opinion- distance is
    a relevant factor in opinion updating processes; and the notion that
    opinion-distance on other (more or less related) opinions plays a role, too
    (see previous point). Without such empirical evidence, statements such as
    “how much each agent trusts another agent should be a function of the
    distance between their opinions on the subject they are debating” sound a
    bit unfounded."
  - "Likewise, I was expecting to see more reference to macro-level empirical
    work, which could either help justify the assumptions embedded in the model
    proposed by the authors, or be used as a validation-benchmark for the
    aggregate levels outcomes generated by the model. Without such empirical
    reference, claims made e.g. in the first phrases in the conclusions section
    feel unwarranted or at least as lacking empirical grounding. And then
    ultimately, one has to resort to much weaker claims such as the ones made in
    the abstract (where the use of the word ‘might’ gives away that in fact, we
    really do not know for sure if this is how things play out in real life).”

    -  We have modified the first paragraph of section 1 to indicate the
       relevant literature about geometric models. We have also added a new
       second paragraph at Section 1 where a small review of the literature of
       Bounded Confidence opinion models is introduced as well as a very concise
       review of the cognitive aspects on why we trust better those who agree
       with us. The new second paragraph in the Introduction provides empirical
       justification for the assumptions. We’ve added a paragraph to the
       conclusion reinforcing what is the scope of the paper.Empirical
       calibration/validation and many other extensions were beyond the scope of
       the paper and left for a future study.
